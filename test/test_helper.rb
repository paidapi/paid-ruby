require 'paid'
require 'test/unit'
require 'mocha/setup'
require 'stringio'
require 'shoulda'
require File.expand_path('../test_data', __FILE__)
require File.expand_path('../mock_resource', __FILE__)

# monkeypatch request methods
module Paid
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end

  def self.execute_request(opts)
    headers = opts[:headers]
    post_params = opts[:payload]
    case opts[:method]
    when :get then @mock_rest_client.get opts[:url], headers, post_params
    when :put then @mock_rest_client.put opts[:url], headers, post_params
    when :post then @mock_rest_client.post opts[:url], headers, post_params
    when :delete then @mock_rest_client.delete opts[:url], headers, post_params
    end
  end
end

class Test::Unit::TestCase
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
