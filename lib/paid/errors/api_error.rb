module Paid
  class APIError < PaidError
    attr_reader :api_method

    def initialize(message = nil, api_method = nil)
      @message = message || response_message
      @api_method = api_method
    end

    def code
      @api_method.response_code if @api_method
    end

    def body
      @api_method.response_body if @api_method
    end

    def json
      begin
        @api_method.response_json if @api_method
      rescue APIError
        nil
      end
    end

    def response_message
      begin
        json[:error][:message]
      rescue
        nil
      end
    end

    def to_s
      if code.nil?
        return @message
      else
        return "(Status #{code}) #{@message}"
      end
    end
  end
end

