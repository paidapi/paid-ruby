require File.expand_path('../../test_helper', __FILE__)

module Paid
  class TransactionTest < Test::Unit::TestCase
    setup do
      @transaction_url = "#{Paid.api_base}/v0/transactions"
    end

    context 'Transaction class' do
      should 'be retrieveable' do
        id = "transaction_id"
        @mock.expects(:get).once.with("#{@transaction_url}/#{id}", anything, anything).returns(test_response(test_transaction))
        transaction = Paid::Transaction.retrieve(id)
        assert(transaction.is_a?(Paid::Transaction))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@transaction_url, anything, test_transaction).returns(test_response(test_transaction))
        transaction = Paid::Transaction.create(test_transaction)
        assert(transaction.is_a?(Paid::Transaction))
        assert_equal(test_transaction[:id], transaction.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_transaction_list))

        transactions = Paid::Transaction.all

        assert(transactions.is_a?(Paid::APIList))
        transactions.each do |transaction|
          assert(transaction.is_a?(Paid::Transaction))
        end
      end
    end

    context 'Transaction instance' do
      setup do
        @transaction = Paid::Transaction.new(test_transaction[:id])
      end

      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@transaction_url}/#{@transaction.id}", anything, anything).returns(test_response(test_transaction))
        @transaction.refresh
        assert_equal(test_transaction[:description], @transaction.description)
      end

      should 'be updateable' do
        transaction = Paid::Transaction.new(test_transaction)
        transaction.description = "new description"

        @mock.expects(:put).once.with do |url, headers, params|
          params == transaction.changed_attributes && url == "#{@transaction_url}/#{transaction.id}"
        end.returns(test_response(test_transaction))

        # This should update this instance with test_transaction since it was returned
        transaction.save
        assert_equal(test_transaction[:description], transaction.description)
      end

      should 'be able to mark as paid' do
        paid_on = "2015-01-01"
        response = test_response(test_invoice.merge(:paid => true, :paid_on => paid_on))
        @mock.expects(:post).once.with("#{@transaction_url}/#{@transaction.id}/mark_as_paid", anything, { :paid_on => paid_on }).returns(response)

        assert(!@transaction.paid)
        @transaction.mark_as_paid(:paid_on => paid_on)
        assert_equal(paid_on, @transaction.paid_on)
        assert(@transaction.paid)
      end
    end


    context 'Retrieved Paid::Transaction instance' do
      setup do
        @mock.expects(:get).once.returns(test_response(test_transaction))
        @transaction = Paid::Transaction.retrieve('transaction_id')
      end

      should 'have the id attribute' do
        assert_equal(test_transaction[:id], @transaction.id)
      end

      should 'have the object attribute' do
        assert_equal(test_transaction[:object], @transaction.object)
      end

      should 'have the amount attribute' do
        assert_equal(test_transaction[:amount], @transaction.amount)
      end

      should 'have the description attribute' do
        assert_equal(test_transaction[:description], @transaction.description)
      end

      should 'have the customer attribute' do
        assert_equal(test_transaction[:customer], @transaction.customer)
      end

      should 'have the paid attribute' do
        assert_equal(test_transaction[:paid], @transaction.paid)
      end

      should 'have the paid_on attribute' do
        assert_equal(test_transaction[:paid_on], @transaction.paid_on)
      end

      should 'have the properties attribute' do
        assert_equal(test_transaction[:properties], @transaction.properties)
      end

      should 'have the invoice attribute' do
        assert_equal(test_transaction[:invoice], @transaction.invoice)
      end

    end

    should 'be registered' do
      assert(APIClass.subclasses.include?(Paid::Transaction))
      assert_equal(Paid::Transaction, APIClass.subclass_fetch("transaction"))
    end


  end
end
