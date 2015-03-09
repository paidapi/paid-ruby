require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ApiResourceTest < Test::Unit::TestCase

    should 'have an id attribute' do
      assert(Paid::APIResource.method_defined?(:id))
      assert(Paid::APIResource.method_defined?(:id=))
    end

    should 'have an object attribute' do
      assert(Paid::APIResource.method_defined?(:object))
      assert(Paid::APIResource.method_defined?(:object=))
    end

    should 'have a default path' do
      mr = MockResource.new('fake_id')
      assert_equal("#{MockResource.path}/fake_id", mr.path)
    end

    should 'raise an InvalidRequestError when no ID is present for instance path' do
      @mock.expects(:get).never
      c = MockResource.new
      assert_raises(Paid::InvalidRequestError) { c.refresh }
    end

  end
end
