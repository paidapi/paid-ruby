require File.expand_path('../../test_helper', __FILE__)

module Paid
  class PlanTest < Test::Unit::TestCase
    should "retrieve should retrieve plans" do
      @mock.expects(:get).once.returns(test_response(test_plan))
      i = Paid::Plan.retrieve('in_test_plan')
      assert_equal 'pl_test_plan', i.id
    end

    should "create should create a new plan" do
      @mock.expects(:post).once.returns(test_response(test_plan))
      i = Paid::Plan.create
      assert_equal "pl_test_plan", i.id
    end
  end
end
