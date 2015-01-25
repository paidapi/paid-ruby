# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ApiResourceTest < Test::Unit::TestCase
    should "creating a new APIResource should not fetch over the network" do
      @mock.expects(:get).never
      Paid::Customer.new("someid")
    end

    should "creating a new APIResource from a hash should not fetch over the network" do
      @mock.expects(:get).never
      Paid::Customer.construct_from({
        :id => "somecustomer",
        :object => "customer",
        :email => 'someone@example.com',
        :name => 'Some Business',
        :account_id => 'acct_1234'
      })
    end

    should "setting an attribute should not cause a network request" do
      @mock.expects(:get).never
      @mock.expects(:post).never
      c = Paid::Customer.new("test_customer");
      c.name = 'Another Name'
    end

    should "accessing id should not issue a fetch" do
      @mock.expects(:get).never
      c = Paid::Customer.new("test_customer")
      c.id
    end

    should "not specifying api credentials should raise an exception" do
      Paid.api_key = nil
      assert_raises Paid::AuthenticationError do
        Paid::Customer.new("test_customer").refresh
      end
    end

    should "specifying api credentials containing whitespace should raise an exception" do
      Paid.api_key = "key "
      assert_raises Paid::AuthenticationError do
        Paid::Customer.new("test_customer").refresh
      end
    end

    should "specifying invalid api credentials should raise an exception" do
      Paid.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      assert_raises Paid::AuthenticationError do
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Paid::Customer.retrieve("failing_customer")
      end
    end

    should "AuthenticationErrors should have an http status, http body, and JSON body" do
      Paid.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      begin
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Paid::Customer.retrieve("failing_customer")
      rescue Paid::AuthenticationError => e
        assert_equal(401, e.http_status)
        assert_equal(true, !!e.http_body)
        assert_equal(true, !!e.json_body[:error][:message])
        assert_equal(test_invalid_api_key_error[:error][:message], e.json_body[:error][:message])
      end
    end

    should "send paid account as header when set" do
      paid_account = "acct_0000"
      Paid.expects(:execute_request).with do |opts|
        opts[:headers][:paid_account] == paid_account
      end.returns(test_response(test_transaction))

      Paid::Transaction.create({:amount => 100},
                            {:paid_account => paid_account, :api_key => 'sk_test_local'})
    end

    should "not send paid account as header when not set" do
      Paid.expects(:execute_request).with do |opts|
        opts[:headers][:paid_account].nil?
      end.returns(test_response(test_transaction))

      Paid::Transaction.create(
        {
          :amount => 200,
          :description => 'This is a description.',
          :customer => 'somecustomer'

        },
        'sk_test_local'
      )
    end

    context "when specifying per-object credentials" do
      context "with no global API key set" do
        should "use the per-object credential when creating" do
          Paid.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == 'Bearer sk_test_local'
          end.returns(test_response(test_transaction))

          Paid::Transaction.create(
            {
              :amount => 200,
              :description => 'This is a description.',
              :customer => 'somecustomer'
            },
            'sk_test_local'
          )
        end
      end

      context "with a global API key set" do
        setup do
          Paid.api_key = "global"
        end

        teardown do
          Paid.api_key = nil
        end

        should "use the per-object credential when creating" do
          Paid.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == 'Bearer local'
          end.returns(test_response(test_transaction))

          Paid::Transaction.create(
            {
              :amount => 200,
              :description => 'This is a description.',
              :customer => 'somecustomer'
            },
            'local'
          )
        end

        should "use the per-object credential when retrieving and making other calls" do
          Paid.expects(:execute_request).with do |opts|
            opts[:url] == "#{Paid.api_base}/v0/transactions/tr_test_transaction" &&
              opts[:headers][:authorization] == 'Bearer local'
          end.returns(test_response(test_transaction))

          ch = Paid::Transaction.retrieve('tr_test_transaction', 'local')
        end
      end
    end

    context "with valid credentials" do
      should "send along the idempotency-key header" do
        Paid.expects(:execute_request).with do |opts|
          opts[:headers][:idempotency_key] == 'bar'
        end.returns(test_response(test_transaction))

        Paid::Transaction.create(
          {
            :amount => 200,
            :description => 'This is a description.',
            :customer => 'somecustomer'
          }, 
          {
            :idempotency_key => 'bar',
            :api_key => 'local',
          }
        )
      end

      should "urlencode values in GET params" do
        response = test_response(test_transaction_array)
        @mock.expects(:get).with("#{Paid.api_base}/v0/transactions?customer=test%20customer", nil, nil).returns(response)
        transactions = Paid::Transaction.all(:customer => 'test customer').data
        assert transactions.kind_of? Array
      end

      should "a 400 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 400)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Paid::Customer.retrieve("foo")
        rescue Paid::InvalidRequestError => e
          assert_equal(400, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "a 401 should give an AuthenticationError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 401)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Paid::Customer.retrieve("foo")
        rescue Paid::AuthenticationError => e
          assert_equal(401, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "a 404 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Paid::Customer.retrieve("foo")
        rescue Paid::InvalidRequestError => e
          assert_equal(404, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "setting a nil value for a param should exclude that param from the request" do
        @mock.expects(:get).with do |url, api_key, params|
          uri = URI(url)
          query = CGI.parse(uri.query)
          (url =~ %r{^#{Paid.api_base}/v0/transactions?} &&
           query.keys.sort == ['offset', 'sad'])
        end.returns(test_response({ :count => 1, :data => [test_transaction] }))
        Paid::Transaction.all(:count => nil, :offset => 5, :sad => false)

        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Paid.api_base}/v0/transactions" &&
            api_key.nil? &&
            CGI.parse(params) == { 'amount' => ['100'] }
        end.returns(test_response({ :count => 1, :data => [test_transaction] }))
        Paid::Transaction.create(:amount => 100)
      end

      should "requesting with a unicode ID should result in a request" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.with("#{Paid.api_base}/v0/customers/%E2%98%83", nil, nil).raises(RestClient::ExceptionWithResponse.new(response, 404))
        c = Paid::Customer.new("☃")
        assert_raises(Paid::InvalidRequestError) { c.refresh }
      end

      should "requesting with no ID should result in an InvalidRequestError with no request" do
        c = Paid::Customer.new
        assert_raises(Paid::InvalidRequestError) { c.refresh }
      end

      should "making a GET request with parameters should have a query string and no body" do
        params = { :limit => 1 }
        @mock.expects(:get).once.with("#{Paid.api_base}/v0/transactions?limit=1", nil, nil).returns(test_response([test_transaction]))
        Paid::Transaction.all(params)
      end

      should "making a POST request with parameters should have a body and no query string" do
        params = { :amount => 100, :alias => 'test_alias' }
        @mock.expects(:post).once.with do |url, get, post|
          get.nil? && CGI.parse(post) == {'amount' => ['100'], 'alias' => ['test_alias']}
        end.returns(test_response(test_transaction))
        Paid::Transaction.create(params)
      end

      should "loading an object should issue a GET request" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        c = Paid::Customer.new("test_customer")
        c.refresh
      end

      should "using array accessors should be the same as the method interface" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        c = Paid::Customer.new("test_customer")
        c.refresh
        assert_equal c.created, c[:created]
        assert_equal c.created, c['created']
        c['created'] = 12345
        assert_equal c.created, 12345
      end

      should "accessing a property other than id or parent on an unfetched object should fetch it" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        c = Paid::Customer.new("test_customer")
        c.transactions
      end

      should "updating an object should issue a POST request with only the changed properties" do
        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Paid.api_base}/v0/customers/c_test_customer" && api_key.nil? && CGI.parse(params) == {'description' => ['another_mn']}
        end.once.returns(test_response(test_customer))
        c = Paid::Customer.construct_from(test_customer)
        c.description = "another_mn"
        c.save
      end

      should "updating should merge in returned properties" do
        @mock.expects(:post).once.returns(test_response(test_customer))
        c = Paid::Customer.new("c_test_customer")
        c.description = "another_mn"
        c.save
        # assert_equal false, c.livemode
      end

      should "deleting should send no props and result in an object that has no props other deleted" do
        @mock.expects(:get).never
        @mock.expects(:post).never
        @mock.expects(:delete).with("#{Paid.api_base}/v0/customers/c_test_customer", nil, nil).once.returns(test_response({ "id" => "test_customer", "deleted" => true }))

        c = Paid::Customer.construct_from(test_customer)
        c.delete
        assert_equal true, c.deleted

        assert_raises NoMethodError do
          c.livemode
        end
      end

      should "loading an object with properties that have specific types should instantiate those classes" do
        @mock.expects(:get).once.returns(test_response(test_transaction))
        t = Paid::Transaction.retrieve("test_transaction")
        assert t.kind_of?(Paid::PaidObject) && t.object == 'transaction'
      end

      should "loading all of an APIResource should return an array of recursively instantiated objects" do
        @mock.expects(:get).once.returns(test_response(test_transaction_array))
        t = Paid::Transaction.all.data
        assert t.kind_of? Array
        assert t[0].kind_of? Paid::Transaction
        assert t[0].kind_of?(Paid::PaidObject) && t[0].object == 'transaction'
      end

      context "error checking" do

        should "404s should raise an InvalidRequestError" do
          response = test_response(test_missing_id_error, 404)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))

          rescued = false
          begin
            Paid::Customer.new("test_customer").refresh
            assert false #shouldn't get here either
          rescue Paid::InvalidRequestError => e # we don't use assert_raises because we want to examine e
            rescued = true
            assert e.kind_of? Paid::InvalidRequestError
            assert_equal "id", e.param
            assert_equal "Missing id", e.message
          end

          assert_equal true, rescued
        end

        should "5XXs should raise an APIError" do
          response = test_response(test_api_error, 500)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 500))

          rescued = false
          begin
            Paid::Customer.new("test_customer").refresh
            assert false #shouldn't get here either
          rescue Paid::APIError => e # we don't use assert_raises because we want to examine e
            rescued = true
            assert e.kind_of? Paid::APIError
          end

          assert_equal true, rescued
        end
      end
    end
  end
end
