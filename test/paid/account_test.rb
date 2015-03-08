require File.expand_path('../../test_helper', __FILE__)

module Paid
  class AccountTest < Test::Unit::TestCase
    setup do
      @account_url = "#{Paid.api_base}/v0/account"
    end

    should 'be retrievable' do
      @mock.expects(:get).once.with(@account_url, anything, anything).returns(test_response(test_account))
      a = Paid::Account.retrieve
      assert(a.is_a?(Paid::Account))
      assert_equal(test_account[:id], a.id)
    end

    context 'Retrieved Paid::Account instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_account))
        @account = Paid::Account.retrieve
      end

      should 'have the id attribute' do
        assert_equal(test_account[:id], @account.id)
      end

      should 'have the object attribute' do
        assert_equal(test_account[:object], @account.object)
      end

      should 'have the business_name attribute' do
        assert_equal(test_account[:business_name], @account.business_name)
      end

      should 'have the business_url attribute' do
        assert_equal(test_account[:business_url], @account.business_url)
      end

      should 'have the business_logo attribute' do
        assert_equal(test_account[:business_logo], @account.business_logo)
      end
    end

    should 'be registered' do
      assert(APIClass.subclasses.include?(Paid::Account))
      assert_equal(Paid::Account, APIClass.subclass_fetch("account"))
    end

  end
end
