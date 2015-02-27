require File.expand_path('../../test_helper', __FILE__)

module Paid
  class PropertiesTest < Test::Unit::TestCase
    setup do
      @properties_supported = {
        transaction: {
          new: Paid::Transaction.method(:new),
          test: method(:test_transaction),
          url: "/v0/transactions/#{test_transaction[:id]}"
        },
        customer: {
          new: Paid::Customer.method(:new),
          test: method(:test_customer),
          url: "/v0/customers/#{test_customer[:id]}"
        }
      }

      @base_url = 'https://api.paidapi.com'
    end

    should 'not touch properties' do
      update_actions = ->(obj) { obj.description = 'test' }
      check_properties({ properties: { 'initial' => 'true' } },
                     'description=test',
                     update_actions)
    end

    should 'update properties as a whole' do
      update_actions = ->(obj) { obj.properties = { 'uuid' => '6735' } }
      check_properties({ properties: {} },
                     'properties[uuid]=6735',
                     update_actions)

      if is_greater_than_ruby_1_9?
        check_properties({ properties: { initial: 'true' } },
                       'properties[uuid]=6735&properties[initial]=',
                       update_actions)
      end
    end

    should 'update properties keys individually' do
      update_actions = ->(obj) { obj.properties['txn_id'] = '134a13' }
      check_properties({ properties: { 'initial' => 'true' } },
                     'properties[txn_id]=134a13',
                     update_actions)
    end

    should 'clear properties as a whole' do
      update_actions = ->(obj) { obj.properties = nil }
      check_properties({ properties: { 'initial' => 'true' } },
                     'properties=',
                     update_actions)
    end

    should 'clear properties keys individually' do
      update_actions = ->(obj) { obj.properties['initial'] = nil }
      check_properties({ properties: { 'initial' => 'true' } },
                     'properties[initial]=',
                     update_actions)
    end

    should 'handle combinations of whole and partial properties updates' do
      if is_greater_than_ruby_1_9?
        update_actions = lambda do |obj|
          obj.properties = { 'type' => 'summer' }
          obj.properties['uuid'] = '6735'
        end
        params = { properties: { 'type' => 'summer', 'uuid' => '6735' } }
        curl_args = Paid.uri_encode(params)
        check_properties({ properties: { 'type' => 'christmas' } },
                       curl_args,
                       update_actions)
      end
    end

    def check_properties(initial_params, curl_args, properties_update)
      @properties_supported.each do |_name, methods|
        neu = methods[:new]
        test = methods[:test]
        url = @base_url + methods[:url]

        initial_test_obj = test.call(initial_params)
        @mock.expects(:get).once.returns(test_response(initial_test_obj))

        final_test_obj = test.call
        @mock.expects(:post).once
          .returns(test_response(final_test_obj))
          .with(url, nil, curl_args)

        obj = neu.call('test')
        obj.refresh
        properties_update.call(obj)
        obj.save
      end
    end

    def is_greater_than_ruby_1_9?
      version = RUBY_VERSION.dup  # clone preserves frozen state
      Gem::Version.new(version) >= Gem::Version.new('1.9')
    end
  end
end
