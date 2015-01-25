require File.expand_path('../../test_helper', __FILE__)

module Paid
  class CustomerTest < Test::Unit::TestCase
    should "customers should be listable" do
      @mock.expects(:get).once.returns(test_response(test_customer_array))
      c = Paid::Customer.all.data
      assert c.kind_of? Array
      assert c[0].kind_of? Paid::Customer
    end

    should "customers should be deletable" do
      @mock.expects(:delete).once.returns(test_response(test_customer({:deleted => true})))
      c = Paid::Customer.new("test_customer")
      c.delete
      assert c.deleted
    end

    should "customers should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_customer({:mnemonic => "foo"})))
      @mock.expects(:post).once.returns(test_response(test_customer({:mnemonic => "bar"})))
      c = Paid::Customer.new("test_customer").refresh
      assert_equal "foo", c.mnemonic
      c.mnemonic = "bar"
      c.save
      assert_equal "bar", c.mnemonic
    end

    should "create should return a new customer" do
      @mock.expects(:post).once.returns(test_response(test_customer))
      c = Paid::Customer.create
      assert_equal "c_test_customer", c.id
    end
  end
end
