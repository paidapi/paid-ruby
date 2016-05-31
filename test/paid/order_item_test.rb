require File.expand_path('../../test_helper', __FILE__)

module Paid
  class OrderItemTest < Test::Unit::TestCase
    setup do
      @order_item_url = "#{Paid.api_base}/order_items"
    end

    context 'OrderItem class' do
      should 'be retrieveable' do
        id = "order_item_id"
        @mock.expects(:get).once.with("#{@order_item_url}/#{id}", anything, anything).returns(test_response(test_order_item))
        order_item = Paid::OrderItem.retrieve(id)
        assert(order_item.is_a?(Paid::OrderItem))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@order_item_url, anything, test_order_item).returns(test_response(test_order_item))
        order_item = Paid::OrderItem.create(test_order_item)
        assert(order_item.is_a?(Paid::OrderItem))
        assert_equal(test_order_item[:id], order_item.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_order_item_list))

        order_items = Paid::OrderItem.all

        assert(order_items.is_a?(Paid::APIList))
        order_items.each do |order_item|
          assert(order_item.is_a?(Paid::OrderItem))
        end
      end
    end

    context 'OrderItem instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@order_item_url}/#{test_order_item[:id]}", anything, anything).returns(test_response(test_order_item))
        order_item = Paid::OrderItem.new(test_order_item[:id])
        order_item.refresh
        assert_equal(test_order_item[:name], order_item.name)
      end

      should 'be updateable' do
        order_item = Paid::OrderItem.new(test_order_item)
        order_item.name = "new name"
        order_item.description = "new description"

        @mock.expects(:put).once.with do |url, headers, params|
          !params.nil? && url == "#{@order_item_url}/#{order_item.id}"
        end.returns(test_response(test_order_item))

        # This should update this instance with test_order_item since it was returned
        order_item.save
        assert_equal(test_order_item[:name], order_item.name)
        assert_equal(test_order_item[:description], order_item.description)
      end
    end


    context 'Retrieved Paid::OrderItem instance' do
      setup do
        @order_item = Paid::OrderItem.new(test_order_item)
      end

      should 'have the id attribute' do
        assert_equal(test_order_item[:id], @order_item.id)
      end

      should 'have the object attribute' do
        assert_equal(test_order_item[:object], @order_item.object)
      end

      should 'have the order attribute' do
        assert_equal(test_order_item[:order], @order_item.order)
      end

      should 'have the plan_item attribute' do
        assert_equal(test_order_item[:plan_item], @order_item.plan_item)
      end

      should 'have the product attribute' do
        assert_equal(test_order_item[:product], @order_item.product)
      end

      should 'have the service_ends_on attribute' do
        assert_equal(test_order_item[:service_ends_on], @order_item.service_ends_on)
      end

      should 'have the service_starts_on attribute' do
        assert_equal(test_order_item[:service_starts_on], @order_item.service_starts_on)
      end

      should 'have the transaction attribute' do
        assert_equal(test_order_item[:transaction], @order_item.transaction)
      end
    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::OrderItem))
      assert_equal(Paid::OrderItem, APIResource.api_subclass_fetch("order_item"))
    end

  end
end
