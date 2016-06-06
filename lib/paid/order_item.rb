module Paid
  class OrderItem < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :order
    attr_accessor :plan_item
    attr_accessor :product
    attr_accessor :service_ends_on
    attr_accessor :service_starts_on
    attr_accessor :transaction

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/order_items", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/order_items/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/order_items", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/order_items/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/order_items/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end


    APIResource.register_api_subclass(self, "order_item")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :order => nil,
      :plan_item => nil,
      :product => nil,
      :service_ends_on => nil,
      :service_starts_on => nil,
      :transaction => nil
    }
  end
end
