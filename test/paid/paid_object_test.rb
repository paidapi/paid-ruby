require File.expand_path('../../test_helper', __FILE__)

module Paid
  class PaidObjectTest < Test::Unit::TestCase
    should "implement #respond_to correctly" do
      obj = Paid::PaidObject.construct_from({ :id => 1, :foo => 'bar' })
      assert obj.respond_to?(:id)
      assert obj.respond_to?(:foo)
      assert !obj.respond_to?(:baz)
    end

    should "marshal a paid object correctly" do
      obj = Paid::PaidObject.construct_from({ :id => 1, :name => 'Paid' }, 'apikey')
      m = Marshal.load(Marshal.dump(obj))
      assert_equal 1, m.id
      assert_equal 'Paid', m.name
      assert_equal 'apikey', m.api_key
    end

    should "recursively call to_hash on its values" do
      nested = Paid::PaidObject.construct_from({ :id => 7, :foo => 'bar' })
      obj = Paid::PaidObject.construct_from({ :id => 1, :nested => nested })
      expected_hash = { :id => 1, :nested => { :id => 7, :foo => 'bar' } }
      assert_equal expected_hash, obj.to_hash
    end
  end
end
