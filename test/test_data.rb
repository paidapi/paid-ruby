module Paid
  module TestData
    def test_response(body, code=200)
      # When an exception is raised, restclient clobbers method_missing.  Hence we
      # can't just use the stubs interface.
      body = JSON.generate(body) if !(body.kind_of? String)
      m = mock
      m.instance_variable_set('@paid_values', { :body => body, :code => code })
      def m.body; @paid_values[:body]; end
      def m.code; @paid_values[:code]; end
      m
    end

    def test_alias(params={})
      id = params[:id] || 'al_test_alias'
      {
        :object => "alias",
        :id => id,
        :name => 'test-alias',
        :customer => 'c_test_customer'
      }.merge(params)
    end

    def test_alias_array(params={})
      {
        :data => [test_alias, test_alias, test_alias],
        :object => 'list',
        :url => '/v0/aliases'
      }
    end

    def test_customer(params={})
      id = params[:id] || 'c_test_customer'
      {
        :transactions => [],
        :object => "customer",
        :id => id,
        :created => 1304114758
      }.merge(params)
    end

    def test_customer_array
      {
        :data => [test_customer, test_customer, test_customer],
        :object => 'list',
        :url => '/v0/customers'
      }
    end

    def test_transaction(params={})
      id = params[:id] || 'tr_test_transaction'
      {
        :paid => false,
        :amount => 100,
        :id => id,
        :object => "transaction",
        :description => 'a description',
        :created => 1304114826,
        :customer => 'c_test_customer'
      }.merge(params)
    end

    def test_transaction_array
      {
        :data => [test_transaction, test_transaction, test_transaction],
        :object => 'list',
        :url => '/v0/transactions'
      }
    end

    def test_invoice
      {
        object: "invoice",
        id: "inv_test_invoice",
        summary: nil,
        chase_schedule: [
        "-7",
        "-1",
        "0",
        "1",
        "5",
        "10",
        "15",
        "20",
        "25",
        "30",
        "~1"
        ],
        next_chase_on: nil,
        terms: 30,
        due_date: nil,
        customer: "c_test_customer",
        issued_at: nil
      }
    end

    def test_invalid_api_key_error
      {
        :error => {
          :type => "invalid_request_error",
          :message => "Invalid API Key provided: invalid"
        }
      }
    end

    def test_missing_id_error
      {
        :error => {
          :param => "id",
          :type => "invalid_request_error",
          :message => "Missing id"
        }
      }
    end

    def test_api_error
      {
        :error => {
          :type => "api_error"
        }
      }
    end
  end
end
