require File.expand_path('../../test_helper', __FILE__)

module Paid
  class PlanItemTest < Test::Unit::TestCase
    setup do
      @plan_item_url = "#{Paid.api_base}/plan_items"
    end

    context 'PlanItem class' do
      should 'be retrieveable' do
        id = "plan_item_id"
        @mock.expects(:get).once.with("#{@plan_item_url}/#{id}", anything, anything).returns(test_response(test_plan_item))
        plan_item = Paid::PlanItem.retrieve(id)
        assert(plan_item.is_a?(Paid::PlanItem))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@plan_item_url, anything, test_plan_item).returns(test_response(test_plan_item))
        plan_item = Paid::PlanItem.create(test_plan_item)
        assert(plan_item.is_a?(Paid::PlanItem))
        assert_equal(test_plan_item[:id], plan_item.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_plan_item_list))

        plan_items = Paid::PlanItem.all

        assert(plan_items.is_a?(Paid::APIList))
        plan_items.each do |plan_item|
          assert(plan_item.is_a?(Paid::PlanItem))
        end
      end
    end

    context 'PlanItem instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@plan_item_url}/#{test_plan_item[:id]}", anything, anything).returns(test_response(test_plan_item))
        plan_item = Paid::PlanItem.new(test_plan_item[:id])
        plan_item.refresh
        assert_equal(test_plan_item[:pricing][:quantity], plan_item.pricing[:quantity])
      end

      should 'be updateable' do
        plan_item = Paid::PlanItem.new(test_plan_item)
        plan_item.pricing[:quantity] = 2.0

        @mock.expects(:put).once.with do |url, headers, params|
          !params.nil? && url == "#{@plan_item_url}/#{plan_item.id}"
        end.returns(test_response(test_plan_item))

        # This should update this instance with test_plan_item since it was returned
        plan_item.save
        assert_equal(test_plan_item[:pricing][:quantity], plan_item.pricing[:quantity])
      end
    end


    context 'Retrieved Paid::PlanItem instance' do
      setup do
        @plan_item = Paid::PlanItem.new(test_plan_item)
      end

      should 'have the id attribute' do
        assert_equal(test_plan_item[:id], @plan_item.id)
      end

      should 'have the object attribute' do
        assert_equal(test_plan_item[:object], @plan_item.object)
      end

      should 'have the plan attribute' do
        assert_equal(test_plan_item[:plan], @plan_item.plan)
      end

      should 'have the product attribute' do
        assert_equal(test_plan_item[:product], @plan_item.product)
      end
    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::PlanItem))
      assert_equal(Paid::PlanItem, APIResource.api_subclass_fetch("plan_item"))
    end

  end
end
