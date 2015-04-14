module Paid
  module HeadersBuilder

    def self.build(headers, api_key=nil, auth_key=nil)
      headers ||= {}
      if auth_key
        temp = default_headers.merge(custom_auth_header(auth_key, api_key))
      else
        temp = default_headers.merge(basic_auth_header(api_key))
      end
      temp.merge(headers)
    end

    def self.default_headers
      headers = {
        :user_agent => "Paid/#{Paid.api_version} RubyBindings/#{Paid::VERSION}",
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

    def self.custom_auth_header(key, api_key)
      unless api_key
        raise AuthenticationError.new('No API key provided. Set your API key using "Paid.api_key = <API-KEY>".')
      end

      {
        key => api_key,
      }
    end

    def self.basic_auth_header(api_key)
      unless api_key
        raise AuthenticationError.new('No API key provided. Set your API key using "Paid.api_key = <API-KEY>".')
      end

      base_64_key = Base64.encode64("#{api_key}:")
      {
        "Authorization" => "Basic #{base_64_key}",
      }
    end

    def self.user_agent
      lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"

      {
        :bindings_version => Paid::VERSION,
        :lang => 'ruby',
        :lang_version => lang_version,
        :platform => RUBY_PLATFORM,
        :publisher => 'paid',
        :uname => get_uname
      }
    end

    def self.get_uname
      `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
    rescue Errno::ENOMEM => ex # couldn't create subprocess
      "uname lookup failed"
    end

  end
end





