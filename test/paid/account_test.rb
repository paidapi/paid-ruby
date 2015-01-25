require File.expand_path('../../test_helper', __FILE__)

module Paid
  class AccountTest < Test::Unit::TestCase
    should "account should be retrievable" do
      resp = {:email => "test+bindings@paidapi.com"}
      @mock.expects(:get).once.returns(test_response(resp))
      a = Paid::Account.retrieve
      assert_equal "test+bindings@paidapi.com", a.email
    end
  end
end
