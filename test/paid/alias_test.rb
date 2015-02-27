require File.expand_path('../../test_helper', __FILE__)

module Paid
  # AliasTest
  class AliasTest < Test::Unit::TestCase
    should 'aliases should not be deletable' do
      assert_raises NoMethodError do
        # Expect twice because Paid::Alias.retrieve returns a customer object
        @mock.expects(:get).twice.returns(test_response(test_customer))
        c = Paid::Alias.retrieve('test_alias')
        c.delete
      end
    end

    should 'retrieve should retrieve alias' do
      # Expect twice because Paid::Alias.retrieve returns a customer object
      @mock.expects(:get).twice.returns(test_response(test_alias))
      i = Paid::Alias.retrieve('in_test_alias')
      assert_equal 'al_test_alias', i.id
    end
  end
end
