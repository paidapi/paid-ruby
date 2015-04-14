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

    def test_mock_resource
      {
        :object => 'mock_resource',
        :name => 'test mr name',
        :nested => {
          :id => 'test_nested_id',
          :object => 'nested_resource',
          :price => 500
        },
        :nested_alt_id => 'nested_alt_id',
        :nested_with => {
          :id => 'nested_with_id',
          :price => 500
        },
        :thash => { :some_key => "some value" },
        :tarray => ["abc", "xyz"],
        :id => 'test_mock_resource_id'
      }
    end

    def test_mock_resource_list
      {
        :object => 'list',
        :data => [test_mock_resource, test_mock_resource, test_mock_resource],
      }
    end

    # Resources

    def test_account
      {
        :id => 'account_id',
        :object => 'account',
        :business_name => 'some co inc',
        :business_url => 'http://www.somecoinc.com/',
        :business_logo => 'http://www.somecoinc.com/logo.png'
      }
    end

    def test_customer
      {
        :id => "cus_DLjf9aDKE9fkdncz",
        :object => "customer",
        :name => "Paid",
        :email => "hello@paidapi.com",
        :description => "Obviously this is just a description.",
        :address_line1 => "2261 Market Street",
        :address_line2 => "#567",
        :address_city => "San Francisco",
        :address_state => "CA",
        :address_zip => "94114",
        :phone => "4155069330",
        :allow_ach => true,
        :allow_check => true,
        :allow_credit_card => true,
        :allow_wire => true,
        :terms => 30,
        :billing_type => "invoice",
        :billing_cycle => "manual",
        :stripe_customer_id => nil,
        :external_id => "customer_external_id",
      }
    end

    def test_customer_list
      {
        :data => [test_customer, test_customer, test_customer],
        :object => 'list'
      }
    end

    def test_invoice
      {
        :object => "invoice",
        :id => "inv_8KAu1BU4PiYnPE49XtN0A",
        :summary => nil,
        :chase_schedule => ["-7", "-1", "0", "1", "5", "10", "15", "20", "25", "30", "~1"],
        :next_chase_on => nil,
        :terms => 30,
        :customer => "cus_XJuvZeQXQgKMrpUAzPbGA",
        :issued_at => nil,
        :paid => false,
        :url => "https://payments.paid.com/invoices/inv_8KAu1BU4PiYnPE49XtN0A"
      }
    end

    def test_invoice_list
      {
        :data => [test_invoice, test_invoice, test_invoice],
        :object => 'list'
      }
    end

    def test_transaction
      {
        :id => 'tr_a09sd8a8s9df7asdf98',
        :object => "transaction",
        :amount => 100,
        :description => 'a description',
        :customer => 'cus_test_customer',
        :paid => false,
        :paid_on => nil,
        :properties => {},
        :invoice => 'inv_8KAu1BU4PiYnPE49XtN0A'
      }
    end

    def test_transaction_list
      {
        :data => [test_transaction, test_transaction, test_transaction],
        :object => 'list'
      }
    end

    def test_plan
      {
        :object => "plan",
        :id => "pl_F0h9MWFeZyXKVPHZ0bIcfQ",
        :created_at => 1425494198,
        :description => "Plan for testing stuff",
        :name => "Test Plan",
        :interval => "year",
        :interval_count => 1,
        :amount => 50000
      }
    end

    def test_plan_list
      {
        :data => [test_plan, test_plan, test_plan],
        :object => 'list'
      }
    end

    def test_event(data=test_invoice, type="invoice.generated")
      {
        :id => "evt_b8DZtUtZs8sxs0EsCcMg",
        :object => "event",
        :created_at => 1421719697,
        :type => type,
        :data => data
      }
    end

    def test_event_list
      {
        :data => [test_event, test_event(test_customer, "customer.created"), test_event(test_plan, "plan.created")],
        :object => 'list'
      }
    end

    def test_subscription
      {
        :id => "sub_IQSGpEv9mKr6NBkKTr4qfA",
        :object => "subscription",
        :created_at => 1425494242,
        :starts_on => "2015-03-04",
        :next_transaction_on => "2016-03-04",
        :plan => test_plan,
        :customer => "cus_VygTkKwTBgfjV3xo60wRRA",
        :started_at => 1425494242,
        :ended_at => 0,
        :cancelled_at => 0
      }
    end

    def test_subscription_list
      {
        :data => [test_subscription, test_subscription, test_subscription],
        :object => 'list'
      }
    end



    # Errors
    def test_api_error
      {
        :error => {
          :type => "api_error"
        }
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

  end
end
