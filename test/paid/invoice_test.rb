require File.expand_path('../../test_helper', __FILE__)

module Paid
  class InvoiceTest < Test::Unit::TestCase
    should "retrieve should retrieve invoices" do
      @mock.expects(:get).once.returns(test_response(test_invoice))
      i = Paid::Invoice.retrieve('in_test_invoice')
      assert_equal 'inv_test_invoice', i.id
    end

    should "create should create a new invoice" do
      @mock.expects(:post).once.returns(test_response(test_invoice))
      i = Paid::Invoice.create
      assert_equal "inv_test_invoice", i.id
    end

    should "charges should be issuable" do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(test_response({:id => "ch_test_charge", :issued_at => 123467890}))
      i = Paid::Invoice.new("test_charge")
      i.issue
      assert !i.issued_at.nil?
    end
  end
end
