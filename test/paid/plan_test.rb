require File.expand_path('../../test_helper', __FILE__)

module Paid
  class PlanTest < Test::Unit::TestCase
    setup do
      @plan_url = "#{Paid.api_base}/v0/plans"
    end

    context 'Plan class' do
      should 'be retrieveable' do
        id = "plan_id"
        @mock.expects(:get).once.with("#{@plan_url}/#{id}", anything, anything).returns(test_response(test_plan))
        plan = Paid::Plan.retrieve(id)
        assert(plan.is_a?(Paid::Plan))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@plan_url, anything, test_plan).returns(test_response(test_plan))
        plan = Paid::Plan.create(test_plan)
        assert(plan.is_a?(Paid::Plan))
        assert_equal(test_plan[:id], plan.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_plan_list))

        plans = Paid::Plan.all

        assert(plans.is_a?(Paid::APIList))
        plans.each do |plan|
          assert(plan.is_a?(Paid::Plan))
        end
      end
    end

    context 'Plan instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@plan_url}/#{test_plan[:id]}", anything, anything).returns(test_response(test_plan))
        plan = Paid::Plan.new(test_plan[:id])
        plan.refresh
        assert_equal(test_plan[:name], plan.name)
      end
    end


    context 'Retrieved Paid::Plan instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_plan))
        @plan = Paid::Plan.retrieve('plan_id')
      end

      should 'have the id attribute' do
        assert_equal(test_plan[:id], @plan.id)
      end

      should 'have the object attribute' do
        assert_equal(test_plan[:object], @plan.object)
      end

      should 'have the created_at attribute' do
        assert_equal(test_plan[:created_at], @plan.created_at)
      end

      should 'have the description attribute' do
        assert_equal(test_plan[:description], @plan.description)
      end

      should 'have the name attribute' do
        assert_equal(test_plan[:name], @plan.name)
      end

      should 'have the interval attribute' do
        assert_equal(test_plan[:interval], @plan.interval)
      end

      should 'have the interval_count attribute' do
        assert_equal(test_plan[:interval_count], @plan.interval_count)
      end

      should 'have the amount attribute' do
        assert_equal(test_plan[:amount], @plan.amount)
      end

    end

    should 'be registered' do
      assert(APIClass.subclasses.include?(Paid::Plan))
      assert_equal(Paid::Plan, APIClass.subclass_fetch("plan"))
    end


  end
end
