require File.expand_path('../../test_helper', __FILE__)

module Paid
  class SubscriptionTest < Test::Unit::TestCase
    setup do
      @subscription_url = "#{Paid.api_base}/subscriptions"
    end

    context 'Subscription class' do
      should 'be retrieveable' do
        id = "subscription_id"
        @mock.expects(:get).once.with("#{@subscription_url}/#{id}", anything, anything).returns(test_response(test_subscription))
        subscription = Paid::Subscription.retrieve(id)
        assert(subscription.is_a?(Paid::Subscription))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@subscription_url, anything, test_subscription).returns(test_response(test_subscription))
        subscription = Paid::Subscription.create(test_subscription)
        assert(subscription.is_a?(Paid::Subscription))
        assert_equal(test_subscription[:id], subscription.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_subscription_list))

        subscriptions = Paid::Subscription.all

        assert(subscriptions.is_a?(Paid::APIList))
        subscriptions.each do |subscription|
          assert(subscription.is_a?(Paid::Subscription))
        end
      end
    end

    context 'Subscription instance' do
      setup do
        @subscription = Paid::Subscription.new(test_subscription[:id])
      end

      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@subscription_url}/#{@subscription.id}", anything, anything).returns(test_response(test_subscription))
        @subscription.refresh
        assert_equal(test_subscription[:customer], @subscription.customer)
      end

      should 'be cancellable' do
        response = test_response(test_subscription.merge(:cancelled_at => 1425494198))
        @mock.expects(:post).once.with("#{@subscription_url}/#{@subscription.id}/cancel", anything, anything).returns(response)

        @subscription.cancel
        assert_equal(1425494198, @subscription.cancelled_at)
      end
    end

    context 'Retrieved Paid::Subscription instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_subscription))
        @subscription = Paid::Subscription.retrieve('subscription_id')
      end

      should 'have the id attribute' do
        assert_equal(test_subscription[:id], @subscription.id)
      end

      should 'have the object attribute' do
        assert_equal(test_subscription[:object], @subscription.object)
      end

      should 'have the created_at attribute' do
        assert_equal(test_subscription[:created_at], @subscription.created_at)
      end

      should 'have the starts_on attribute' do
        assert_equal(test_subscription[:starts_on], @subscription.starts_on)
      end

      should 'have the next_transaction_on attribute' do
        assert_equal(test_subscription[:next_transaction_on], @subscription.next_transaction_on)
      end

      should 'have & convert the plan attribute' do
        assert_equal(test_subscription[:plan][:id], @subscription.plan.id)
        assert(@subscription.plan.is_a?(Paid::Plan))
      end

      should 'have the customer attribute' do
        assert_equal(test_subscription[:customer], @subscription.customer)
      end

      should 'have the started_at attribute' do
        assert_equal(test_subscription[:started_at], @subscription.started_at)
      end

      should 'have the ended_at attribute' do
        assert_equal(test_subscription[:ended_at], @subscription.ended_at)
      end

      should 'have the cancelled_at attribute' do
        assert_equal(test_subscription[:cancelled_at], @subscription.cancelled_at)
      end

    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::Subscription))
      assert_equal(Paid::Subscription, APIResource.api_subclass_fetch("subscription"))
    end

  end
end
