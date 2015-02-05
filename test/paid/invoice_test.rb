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
      @mock.expects(:post).once.returns(test_response({:id => "inv_test_invoice", :issued_at => 123467890}))
      i = Paid::Invoice.new("test_invoice")
      i.issue
      assert !i.issued_at.nil?
    end

    should "charges should be able to be marked as paid" do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(test_response({:id => "inv_test_invoice", :paid => true}))
      i = Paid::Invoice.new("test_invoice")
      i.mark_as_paid
      assert i.paid
    end
  end
end
