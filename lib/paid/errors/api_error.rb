module Paid
  class APIError < PaidError

    def self.generic(rcode, rbody)
      self.new("Invalid response object from API: #{rbody.inspect} " +
               "(HTTP response code was #{rcode})", rcode, rbody)
    end

  end
end
