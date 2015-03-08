# Paid Ruby bindings
# API spec at https://paid.com/docs/api
require 'cgi'
require 'set'
require 'openssl'
require 'rest_client'
require 'json'
require 'base64'

# Version
require 'paid/version'

# Resources
require 'paid/api_class'
require 'paid/api_resource'
require 'paid/api_singleton'
require 'paid/api_list'
require 'paid/util'

# Requires for classes
require 'paid/transaction'
require 'paid/invoice'
require 'paid/event'
require 'paid/customer'
require 'paid/plan'
require 'paid/subscription'
require 'paid/account'

# Errors
require 'paid/errors/paid_error'
require 'paid/errors/api_error'
require 'paid/errors/api_connection_error'
require 'paid/errors/invalid_request_error'
require 'paid/errors/authentication_error'

module Paid
  @api_base = "https://api.paidapi.com"
  @api_key = nil

  class << self
    attr_accessor :api_key, :api_base, :api_test
  end

  def self.api_url(path='')
    "#{@api_base}#{path}"
  end

  def self.request(method, path, params={}, headers={})
    verify_api_key(api_key)

    url = api_url(path)

    request_opts = { :verify_ssl => false }

    if [:get, :head, :delete].include?(method.to_s.downcase.to_sym)
      unless params.empty?
        url += URI.parse(url).query ? '&' : '?' + Util.query_string(params)
      end
      params = nil
    end

    headers = default_headers.update(basic_auth_headers(api_key)).update(headers)
    request_opts.update(:headers => headers,
                        :method => method,
                        :open_timeout => 30,
                        :payload => params,
                        :url => url,
                        :timeout => 60)

    begin
      response = execute_request(request_opts)
    rescue Exception => e
      handle_request_error(e, url)
    end

    parse(response)
  end

  # Mostly here for stubbing out during tests.
  def self.execute_request(opts)
    RestClient::Request.execute(request_opts)
  end

  def self.parse(response)
    begin
      json = JSON.parse(response.body)
    rescue JSON::ParserError
      raise APIError.generic(response.code, response.body)
    end

    Util.symbolize_keys(json)
  end

  def self.default_headers
    headers = {
      :user_agent => "Paid/::API_VERSION:: RubyBindings/#{Paid::VERSION}",
      :content_type => 'application/x-www-form-urlencoded'
    }

    begin
      headers.update(:x_paid_client_user_agent => JSON.generate(user_agent))
    rescue => e
      headers.update(:x_paid_client_raw_user_agent => user_agent.inspect,
                     :error => "#{e} (#{e.class})")
    end
    headers
  end

  def self.basic_auth_headers(api_key=@api_key)
    api_key ||= @api_key
    unless api_key
      raise ArgumentError.new('No API key provided. Set your API key using "Paid.api_key = <API-KEY>".')
    end

    base_64_key = Base64.encode64("#{api_key}:")
    {
      "Authorization" => "Basic #{base_64_key}",
    }
  end

  def self.user_agent
    @uname ||= get_uname
    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"

    {
      :bindings_version => Paid::VERSION,
      :lang => 'ruby',
      :lang_version => lang_version,
      :platform => RUBY_PLATFORM,
      :publisher => 'paid',
      :uname => @uname
    }
  end

  def self.get_uname
    `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
  rescue Errno::ENOMEM => ex # couldn't create subprocess
    "uname lookup failed"
  end

  def self.verify_api_key(api_key)
    unless api_key
      raise AuthenticationError.new('No API key provided. ' +
        'Set your API key using "Paid.api_key = <API-KEY>". ' +
        'You can generate API keys from the Paid web interface. ' +
        'See http://docs.paidapi.com/#authentication for details, or email hello@paidapi.com ' +
        'if you have any questions.')
    end

    if api_key =~ /\s/
      raise AuthenticationError.new('Your API key is invalid, as it contains ' +
        'whitespace. (HINT: You can double-check your API key from the ' +
        'Paid web interface. See http://docs.paidapi.com/#authentication for details, or ' +
        'email hello@paidapi.com if you have any questions.)')
    end
  end

  def self.handle_request_error(error, url)
    # First we see if this is an error with a response, and if it is
    # we check to see if there is an http code and body to work with.
    if error.is_a?(RestClient::ExceptionWithResponse)
      if error.http_code && error.http_body
        handle_api_error(error.http_code, error.http_body)
      end
    end

    # If we got here then the error hasn't been handled yet.
    # Handle it as a connection error.
    handle_connection_error(error, url)

    # Finally if we get here we don't know what type of error it is, so just raise it.
    raise error
  end

  def self.handle_connection_error(error, url)
    message = "An error occurred while connecting to Paid at #{url}."

    case error
    when RestClient::RequestTimeout
      message +=  connection_message

    when RestClient::ServerBrokeConnection
      message = "The connection to the server at (#{url}) broke before the " \
        "request completed. #{connection_message}"

    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Paid's SSL certificate. " \
        "Please make sure that your network is not intercepting certificates. " \
        "(Try going to https://api.paidapi.com/v0 in your browser.) " \
        "If this problem persists, let us know at hello@paidapi.com."

    when SocketError
      message = "Unexpected error when trying to connect to Paid. " \
        "You may be seeing this message because your DNS is not working. " \
        "To check, try running 'host api.paidapi.com' from the command line."

    else
      message = "Unexpected error communicating with Paid. " \
        "If this problem persists, let us know at hello@paidapi.com. #{connection_message}"
    end

    raise APIConnectionError.new(message + "\n\n(Network error: #{error.message}")
  end

  def self.connection_message
    "Please check your internet connection and try again. " \
    "If this problem persists, you should check Paid's service status at " \
    "https://twitter.com/paidstatus, or let us know at hello@paidapi.com."
  end

  def self.handle_api_error(rcode, rbody)
    begin
      error_obj = JSON.parse(rbody)
    rescue JSON::ParserError
      raise APIError.generic(rcode, rbody)
    end
    error_obj = Util.symbolize_keys(error_obj)
    raise APIError.generic(rcode, rbody) unless error = error_obj[:error]

    case rcode
    when 400, 404
      raise InvalidRequestError.new(error[:message], error[:param], rcode, rbody, error_obj)
    when 401
      raise AuthenticationError.new(error[:message], rcode, rbody, error_obj)
    else
      raise APIError.new(error[:message], rcode, rbody, error_obj)
    end
  end

end
