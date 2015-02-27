require File.expand_path('../../test_helper', __FILE__)

module Paid
  # SubscriptionTest
  class SubscriptionTest < Test::Unit::TestCase
    should 'retrieve should retrieve subscriptions' do
      @mock.expects(:get).once.returns(test_response(test_subscription))
      i = Paid::Subscription.retrieve('in_test_subscription')
      assert_equal 'sub_test_subscription', i.id
    end

    should 'create should create a new subscription' do
      @mock.expects(:post).once.returns(test_response(test_subscription))
      i = Paid::Subscription.create
      assert_equal 'sub_test_subscription', i.id
    end

    should 'subscriptions should be cancellable' do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(
        test_response(
          id: 'sub_test_subscription',
          cancelled_at: 123_456_789
        )
      )
      s = Paid::Subscription.new('test_subscription')
      s.cancel
      assert !s.cancelled_at.nil?
    end
  end
end
