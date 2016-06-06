module Paid
  class Order < APIResource
    attr_reader :id
    attr_reader :object
    attr_reader :amount
    attr_accessor :charge_now
    attr_accessor :customer
    attr_accessor :metadata
    attr_accessor :subscription


    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/orders", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/orders/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/orders", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/orders/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/orders/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end


    APIResource.register_api_subclass(self, "order")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :amount => { :readonly => true },
      :charge_now => nil,
      :customer => nil,
      :metadata => nil,
      :subscription => nil
    }
  end
end
