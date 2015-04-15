require 'paid'
require 'test/unit'
require 'mocha/setup'
require 'stringio'
require 'shoulda'
require File.expand_path('../test_data', __FILE__)
# require File.expand_path('../mock_resource', __FILE__)

# monkeypatch request methods
module Paid
  class << self
    attr_accessor :mock_rest_client
  end

  module Requester
    def self.request(method, url, params, headers)
      case method
      when :get then Paid::mock_rest_client.get(url, headers, params)
      when :put then Paid::mock_rest_client.put(url, headers, params)
      when :post then Paid::mock_rest_client.post(url, headers, params)
      when :delete then Paid::mock_rest_client.delete(url, headers, params)
      else
        raise "Invalid method"
      end
    end
  end
end

class ::Test::Unit::TestCase
  include Paid::TestData
  include Mocha

  setup do
    @mock = mock
    Paid.mock_rest_client = @mock
    Paid.api_key="foo"
  end

  teardown do
    Paid.mock_rest_client = nil
    Paid.api_key=nil
  end
end
