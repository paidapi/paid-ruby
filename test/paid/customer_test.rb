require File.expand_path('../../test_helper', __FILE__)

module Paid
  class CustomerTest < Test::Unit::TestCase
    setup do
      @customer_url = "#{Paid.api_base}/v0/customers"
    end

    context 'Customer class' do
      should 'be retrieveable' do
        id = "customer_id"
        @mock.expects(:get).once.with("#{@customer_url}/#{id}", anything, anything).returns(test_response(test_customer))
        customer = Paid::Customer.retrieve(id)
        assert(customer.is_a?(Paid::Customer))
      end

      should 'be retrieveable by external_id' do
        external_id = "external_id_for_cust"
        @mock.expects(:get).once.with("#{@customer_url}/by_external_id/#{external_id}", anything, anything).returns(test_response(test_customer))
        customer = Paid::Customer.by_external_id(external_id)
        assert(customer.is_a?(Paid::Customer))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@customer_url, anything, test_customer).returns(test_response(test_customer))
        customer = Paid::Customer.create(test_customer)
        assert(customer.is_a?(Paid::Customer))
        assert_equal(test_customer[:id], customer.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_customer_list))

        customers = Paid::Customer.all

        assert(customers.is_a?(Paid::APIList))
        customers.each do |customer|
          assert(customer.is_a?(Paid::Customer))
        end
      end
    end

    context 'Customer instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@customer_url}/#{test_customer[:id]}", anything, anything).returns(test_response(test_customer))
        customer = Paid::Customer.new(test_customer[:id])
        customer.refresh
        assert_equal(test_customer[:name], customer.name)
      end

      should 'be updateable' do
        customer = Paid::Customer.new(test_customer)
        customer.name = "new name"
        customer.email = "new_email@domain.com"

        @mock.expects(:put).once.with do |url, headers, params|
          params == customer.changed_attributes && url == "#{@customer_url}/#{customer.id}"
        end.returns(test_response(test_customer))

        # This should update this instance with test_customer since it was returned
        customer.save
        assert_equal(test_customer[:name], customer.name)
        assert_equal(test_customer[:email], customer.email)
      end

      should 'be able to generate an invoice' do
        customer = Paid::Customer.new(test_customer)
        @mock.expects(:post).once.with("#{@customer_url}/#{customer.id}/generate_invoice", anything, anything).returns(test_response(test_invoice))

        invoice = customer.generate_invoice
        assert(invoice.is_a?(Paid::Invoice))
      end

      should 'be able to list invoices' do
        customer = Paid::Customer.new(test_customer)
        @mock.expects(:get).once.with("#{Paid.api_base}#{Paid::Invoice.path}?customer=#{customer.id}", anything, anything).returns(test_response(test_invoice_list))

        invoices = customer.invoices
        assert(invoices.is_a?(Paid::APIList))
        invoices.each do |invoice|
          assert(invoice.is_a?(Paid::Invoice))
        end
      end

      should 'be able to list transactions' do
        customer = Paid::Customer.new(test_customer)
        @mock.expects(:get).once.with("#{Paid.api_base}#{Paid::Transaction.path}?customer=#{customer.id}", anything, anything).returns(test_response(test_transaction_list))

        transactions = customer.transactions
        assert(transactions.is_a?(Paid::APIList))
        transactions.each do |transaction|
          assert(transaction.is_a?(Paid::Transaction))
        end
      end
    end


    context 'Retrieved Paid::Customer instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_customer))
        @customer = Paid::Customer.retrieve('customer_id')
      end

      should 'have the id attribute' do
        assert_equal(test_customer[:id], @customer.id)
      end

      should 'have the object attribute' do
        assert_equal(test_customer[:object], @customer.object)
      end

      should 'have the name attribute' do
        assert_equal(test_customer[:name], @customer.name)
      end

      should 'have the email attribute' do
        assert_equal(test_customer[:email], @customer.email)
      end

      should 'have the description attribute' do
        assert_equal(test_customer[:description], @customer.description)
      end

      should 'have the phone attribute' do
        assert_equal(test_customer[:phone], @customer.phone)
      end

      should 'have the address_line1 attribute' do
        assert_equal(test_customer[:address_line1], @customer.address_line1)
      end

      should 'have the address_line2 attribute' do
        assert_equal(test_customer[:address_line2], @customer.address_line2)
      end

      should 'have the address_city attribute' do
        assert_equal(test_customer[:address_city], @customer.address_city)
      end

      should 'have the address_state attribute' do
        assert_equal(test_customer[:address_state], @customer.address_state)
      end

      should 'have the address_zip attribute' do
        assert_equal(test_customer[:address_zip], @customer.address_zip)
      end

      should 'have the allow_ach attribute' do
        assert_equal(test_customer[:allow_ach], @customer.allow_ach)
      end

      should 'have the allow_wire attribute' do
        assert_equal(test_customer[:allow_wire], @customer.allow_wire)
      end

      should 'have the allow_check attribute' do
        assert_equal(test_customer[:allow_check], @customer.allow_check)
      end

      should 'have the allow_credit_card attribute' do
        assert_equal(test_customer[:allow_credit_card], @customer.allow_credit_card)
      end

      should 'have the terms attribute' do
        assert_equal(test_customer[:terms], @customer.terms)
      end

      should 'have the billing_type attribute' do
        assert_equal(test_customer[:billing_type], @customer.billing_type)
      end

      should 'have the billing_cycle attribute' do
        assert_equal(test_customer[:billing_cycle], @customer.billing_cycle)
      end

      should 'have the stripe_customer_id attribute' do
        assert_equal(test_customer[:stripe_customer_id], @customer.stripe_customer_id)
      end

      should 'have the external_id attribute' do
        assert_equal(test_customer[:external_id], @customer.external_id)
      end

    end

    should 'be registered' do
      assert(APIClass.subclasses.include?(Paid::Customer))
      assert_equal(Paid::Customer, APIClass.subclass_fetch("customer"))
    end

  end
end
