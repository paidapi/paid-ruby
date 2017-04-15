module Paid
  class APIMethod

    attr_accessor :path
    attr_accessor :method
    attr_accessor :params
    attr_accessor :headers

    attr_accessor :response_body
    attr_accessor :response_code
    attr_accessor :error

    attr_accessor :api_key
    attr_accessor :api_base

    def initialize(method, path, params, headers, object, api_key=nil, api_base=nil)
      @api_key = api_key || Paid.api_key
      @api_base = api_base || Paid.api_base

      @method = method.to_sym
      @path = PathBuilder.build(path, object, params)
      @params = ParamsBuilder.build(params)
      @headers = HeadersBuilder.build(headers, @api_key, Paid.auth_header)
    end

    def execute
      begin
        response = Requester.request(method, url, params, headers)
        @response_body = response.body
        @response_code = response.code
      rescue StandardError => e
        @response_body = e.http_body if e.respond_to?(:http_body)
        @response_code = e.http_code if e.respond_to?(:http_code)
        @error = compose_error(e)
        raise @error
      end

      response_json
    end

    def url
      "#{api_base}#{@path}"
    end

    def response_json
      begin
        json = Util.symbolize_keys(JSON.parse(@response_body))
      rescue JSON::ParserError
        if @response_body.is_a?(String) && @response_body.strip.empty?
          {}
        else
          @error = APIError.new("Unable to parse the server response as JSON.", self)
          raise @error
        end
      end
    end

    def compose_error(error)
      msg = "An error occured while making the API call."

      case error
      when RestClient::ExceptionWithResponse
        return error_with_response(error)

      when RestClient::RequestTimeout
        msg = "The request timed out while making the API call."

      when RestClient::ServerBrokeConnection
        msg = "The connection to the server broke before the request completed."

      when SocketError
        msg = "An unexpected error occured while trying to connect to " \
          "the API. You may be seeing this message because your DNS is " \
          "not working. To check, try running 'host #{Paid.api_base}' "\
          "from the command line."

      else
        msg = "An unexpected error occured. If this problem persists let us " \
          "know at #{Paid.support_email}."
      end

      return APIConnectionError.new(msg, self)
    end

    # Handle a few common cases.
    def error_with_response(error)
      message = begin
        response_json[:error][:message]
      rescue
        nil
      end

      message ||= error.message

      case @response_code
      when 401
        return AuthenticationError.new(message, self)
      else
        return APIError.new(message, self)
      end
    end
  end
end
