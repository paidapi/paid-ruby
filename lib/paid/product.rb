module Paid
  class Product < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :description
    attr_accessor :external_id
    attr_accessor :external_metric_id
    attr_accessor :name
    attr_accessor :transaction_description
    attr_accessor :pricing_structure


    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/products", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/products/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/products", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/products/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/products/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end


    APIResource.register_api_subclass(self, "product")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :description => nil,
      :external_id => nil,
      :external_metric_id => nil,
      :name => nil,
      :transaction_description => nil,
      :pricing_structure => nil
    }
  end
end
