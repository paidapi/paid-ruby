require File.expand_path('../../test_helper', __FILE__)

module Paid
  class OrderTest < Test::Unit::TestCase
    setup do
      @order_url = "#{Paid.api_base}/orders"
    end

    context 'Order class' do
      should 'be retrieveable' do
        id = "order_id"
        @mock.expects(:get).once.with("#{@order_url}/#{id}", anything, anything).returns(test_response(test_order))
        order = Paid::Order.retrieve(id)
        assert(order.is_a?(Paid::Order))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@order_url, anything, test_order).returns(test_response(test_order))
        order = Paid::Order.create(test_order)
        assert(order.is_a?(Paid::Order))
        assert_equal(test_order[:id], order.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_order_list))

        orders = Paid::Order.all

        assert(orders.is_a?(Paid::APIList))
        orders.each do |order|
          assert(order.is_a?(Paid::Order))
        end
      end
    end

    context 'Order instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@order_url}/#{test_order[:id]}", anything, anything).returns(test_response(test_order))
        order = Paid::Order.new(test_order[:id])
        order.refresh
        assert_equal(test_order[:amount], order.amount)
      end

      should 'be updateable' do
        order = Paid::Order.new(test_order)
        order.charge_now = true

        @mock.expects(:put).once.with do |url, headers, params|
          !params.nil? && url == "#{@order_url}/#{order.id}"
        end.returns(test_response(test_order))

        # This should update this instance with test_order since it was returned
        order.save
        assert_equal(test_order[:charge_now], order.charge_now)
      end
    end


    context 'Retrieved Paid::Order instance' do
      setup do
        @order = Paid::Order.new(test_order)
      end

      should 'have the id attribute' do
        assert_equal(test_order[:id], @order.id)
      end

      should 'have the object attribute' do
        assert_equal(test_order[:object], @order.object)
      end

      should 'have the amount attribute' do
        assert_equal(test_order[:amount], @order.amount)
      end

      should 'have the charge_now attribute' do
        assert_equal(test_order[:charge_now], @order.charge_now)
      end

      should 'have the customer attribute' do
        assert_equal(test_order[:customer], @order.customer)
      end

      should 'have the metadata attribute' do
        assert_equal(test_order[:metadata], @order.metadata)
      end

      should 'have the subscription attribute' do
        assert_equal(test_order[:subscription], @order.subscription)
      end
    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::Order))
      assert_equal(Paid::Order, APIResource.api_subclass_fetch("order"))
    end

  end
end
