require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ApiListTest < Test::Unit::TestCase

    should 'have an object attribute' do
      assert(Paid::APIList.method_defined?(:object))
      assert(Paid::APIList.method_defined?(:object=))
    end

    should 'have an data attribute' do
      assert(Paid::APIList.method_defined?(:data))
      assert(Paid::APIList.method_defined?(:data=))
    end

  end
end
