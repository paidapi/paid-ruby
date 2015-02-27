require File.expand_path('../../test_helper', __FILE__)

module Paid
  class TransactionTest < Test::Unit::TestCase
    should 'transactions should be listable' do
      @mock.expects(:get).once.returns(test_response(test_transaction_array))
      c = Paid::Transaction.all
      assert c.data.is_a? Array
      c.each do |transaction|
        assert transaction.is_a?(Paid::Transaction)
      end
    end

    should 'transactions should not be deletable' do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_transaction))
        c = Paid::Transaction.retrieve('test_transaction')
        c.delete
      end
    end

    should 'transactions should be updateable' do
      @mock.expects(:get).once.returns(test_response(test_transaction))
      @mock.expects(:post).once.returns(test_response(test_transaction))
      c = Paid::Transaction.new('test_transaction')
      c.refresh
      c.mnemonic = 'New transaction description'
      c.save
    end

    should 'execute should return a new, fully executed transaction when passed correct parameters' do
      @mock.expects(:post).with do |url, api_key, params|
        url == "#{Paid.api_base}/v0/transactions" && api_key.nil? && CGI.parse(params) == {
          'amount' => ['100'],
          'description' => ['a description'],
          'customer' => ['cus_test_customer']
        }
      end.once.returns(test_response(test_transaction))

      c = Paid::Transaction.create(amount: 100,
                                   description: 'a description',
                                   customer: 'cus_test_customer')

      assert !c.paid
    end

    should 'transactions should be able to be marked as paid' do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(test_response(id: 'tr_test_transaction', paid: true))
      t = Paid::Invoice.new('test_transaction')
      t.mark_as_paid
      assert t.paid
    end
  end
end
