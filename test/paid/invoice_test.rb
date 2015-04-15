require File.expand_path('../../test_helper', __FILE__)

module Paid
  class InvoiceTest < Test::Unit::TestCase
    setup do
      @invoice_url = "#{Paid.api_base}/invoices"
    end

    context 'Invoice class' do
      should 'be retrieveable' do
        id = "invoice_id"
        @mock.expects(:get).once.with("#{@invoice_url}/#{id}", anything, anything).returns(test_response(test_invoice))
        invoice = Paid::Invoice.retrieve(id)
        assert(invoice.is_a?(Paid::Invoice))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@invoice_url, anything, test_invoice).returns(test_response(test_invoice))
        invoice = Paid::Invoice.create(test_invoice)
        assert(invoice.is_a?(Paid::Invoice))
        assert_equal(test_invoice[:id], invoice.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_invoice_list))

        invoices = Paid::Invoice.all

        assert(invoices.is_a?(Paid::APIList))
        invoices.each do |invoice|
          assert(invoice.is_a?(Paid::Invoice))
        end
      end
    end

    context 'Invoice instance' do
      setup do
        @invoice = Paid::Invoice.new(test_invoice[:id])
      end

      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@invoice_url}/#{@invoice.id}", anything, anything).returns(test_response(test_invoice))
        @invoice.refresh
        assert_equal(test_invoice[:summary], @invoice.summary)
      end

      should 'be able to mark as paid' do
        via = :ach
        @mock.expects(:post).once.with("#{@invoice_url}/#{@invoice.id}/mark_as_paid", anything, { :via => via }).returns(test_response(test_invoice))

        @invoice.mark_as_paid(:via => via)
        assert_equal(test_invoice[:summary], @invoice.summary)
      end

      should 'be issuable' do
        @mock.expects(:post).once.with("#{@invoice_url}/#{@invoice.id}/issue", anything, anything).returns(test_response(test_invoice))

        @invoice.issue
        assert_equal(test_invoice[:summary], @invoice.summary)
      end
    end


    context 'Retrieved Paid::Invoice instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_invoice))
        @invoice = Paid::Invoice.retrieve('invoice_id')
      end

      should 'have the id attribute' do
        assert_equal(test_invoice[:id], @invoice.id)
      end

      should 'have the object attribute' do
        assert_equal(test_invoice[:object], @invoice.object)
      end

      should 'have the summary attribute' do
        assert_equal(test_invoice[:summary], @invoice.summary)
      end

      should 'have the chase_schedule attribute' do
        assert_equal(test_invoice[:chase_schedule], @invoice.chase_schedule)
      end

      should 'have the next_chase_on attribute' do
        assert_equal(test_invoice[:next_chase_on], @invoice.next_chase_on)
      end

      should 'have the customer attribute' do
        assert_equal(test_invoice[:customer], @invoice.customer)
      end

      should 'have the issued_at attribute' do
        assert_equal(test_invoice[:issued_at], @invoice.issued_at)
      end

      should 'have the terms attribute' do
        assert_equal(test_invoice[:terms], @invoice.terms)
      end

      should 'have the url attribute' do
        assert_equal(test_invoice[:url], @invoice.url)
      end

    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::Invoice))
      assert_equal(Paid::Invoice, APIResource.api_subclass_fetch("invoice"))
    end

  end
end
