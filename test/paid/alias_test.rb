require File.expand_path('../../test_helper', __FILE__)

module Paid
  class AliasTest < Test::Unit::TestCase
    should "aliases should be listable" do
      @mock.expects(:get).once.returns(test_response(test_alias_array))
      c = Paid::Alias.all
      assert c.data.kind_of? Array
      c.each do |paid_alias|
        assert paid_alias.kind_of?(Paid::Alias)
      end
    end

    should "aliases should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_alias))
        c = Paid::Alias.retrieve("test_alias")
        c.delete
      end
    end

    should "execute should return a new, fully executed alias when passed correct parameters" do
      @mock.expects(:post).with do |url, api_key, params|
        url == "#{Paid.api_base}/v0/aliases" && api_key.nil? && CGI.parse(params) == {
            'name' => ['test-alias'],
            'customer' => ['c_test_customer']
        }
      end.once.returns(test_response(test_alias))

      a = Paid::Alias.create({
        :name => 'test-alias',
        :customer => 'c_test_customer'
      })

      assert a.name == 'test-alias'
    end
  end
end
