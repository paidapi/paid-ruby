require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ApiSingletonTest < Test::Unit::TestCase

    should 'have an object attribute' do
      assert(Paid::APISingleton.method_defined?(:object))
      assert(Paid::APISingleton.method_defined?(:object=))
    end

  end
end
