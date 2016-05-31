require File.expand_path('../../test_helper', __FILE__)

module Paid
  class ProductTest < Test::Unit::TestCase
    setup do
      @product_url = "#{Paid.api_base}/products"
    end

    context 'Product class' do
      should 'be retrieveable' do
        id = "product_id"
        @mock.expects(:get).once.with("#{@product_url}/#{id}", anything, anything).returns(test_response(test_product))
        product = Paid::Product.retrieve(id)
        assert(product.is_a?(Paid::Product))
      end

      should 'be createable' do
        @mock.expects(:post).once.with(@product_url, anything, test_product).returns(test_response(test_product))
        product = Paid::Product.create(test_product)
        assert(product.is_a?(Paid::Product))
        assert_equal(test_product[:id], product.id)
      end

      should 'be listable' do
        @mock.expects(:get).once.returns(test_response(test_product_list))

        products = Paid::Product.all

        assert(products.is_a?(Paid::APIList))
        products.each do |product|
          assert(product.is_a?(Paid::Product))
        end
      end
    end

    context 'Product instance' do
      should 'be refreshable' do
        @mock.expects(:get).once.with("#{@product_url}/#{test_product[:id]}", anything, anything).returns(test_response(test_product))
        product = Paid::Product.new(test_product[:id])
        product.refresh
        assert_equal(test_product[:name], product.name)
      end

      should 'be updateable' do
        product = Paid::Product.new(test_product)
        product.name = "new name"
        product.description = "new description"

        @mock.expects(:put).once.with do |url, headers, params|
          !params.nil? && url == "#{@product_url}/#{product.id}"
        end.returns(test_response(test_product))

        # This should update this instance with test_product since it was returned
        product.save
        assert_equal(test_product[:name], product.name)
        assert_equal(test_product[:description], product.description)
      end
    end


    context 'Retrieved Paid::Product instance' do
      setup do
        @product = Paid::Product.new(test_product)
      end

      should 'have the id attribute' do
        assert_equal(test_product[:id], @product.id)
      end

      should 'have the object attribute' do
        assert_equal(test_product[:object], @product.object)
      end

      should 'have the description attribute' do
        assert_equal(test_product[:description], @product.description)
      end

      should 'have the external_id attribute' do
        assert_equal(test_product[:external_id], @product.external_id)
      end

      should 'have the external_metric_id attribute' do
        assert_equal(test_product[:external_metric_id], @product.external_metric_id)
      end

      should 'have the name attribute' do
        assert_equal(test_product[:name], @product.name)
      end

      should 'have the transaction_description attribute' do
        assert_equal(test_product[:transaction_description], @product.transaction_description)
      end

      should 'have the pricing_structure attribute' do
        assert_equal(test_product[:pricing_structure], @product.pricing_structure)
      end
    end

    should 'be registered' do
      assert(APIResource.api_subclasses.include?(Paid::Product))
      assert_equal(Paid::Product, APIResource.api_subclass_fetch("product"))
    end

  end
end
