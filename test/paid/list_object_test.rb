require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ListObjectTest < Test::Unit::TestCase
    should "be able to retrieve full lists given a listobject" do
      @mock.expects(:get).twice.returns(test_response(test_transaction_array))
      c = Paid::Transaction.all
      assert c.kind_of?(Paid::ListObject)
      assert_equal('/v0/transactions', c.url)
      all = c.all
      assert all.kind_of?(Paid::ListObject)
      assert_equal('/v0/transactions', all.url)
      assert all.data.kind_of?(Array)
    end
  end
end