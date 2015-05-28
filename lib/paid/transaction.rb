module Paid
  class Transaction < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :amount
    attr_accessor :description
    attr_accessor :customer
    attr_accessor :paid
    attr_accessor :paid_on
    attr_accessor :properties
    attr_accessor :metadata
    attr_accessor :invoice


    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/transactions", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/transactions/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/transactions", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/transactions/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/transactions/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def delete(params={}, headers={})
      method = APIMethod.new(:delete, "/transactions/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def mark_as_paid(params={}, headers={})
      method = APIMethod.new(:post, "/transactions/:id/mark_as_paid", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def refunds
      RefundList.new(nil, nil, id)
    end

    APIResource.register_api_subclass(self, "transaction")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :amount => nil,
      :description => nil,
      :customer => nil,
      :paid => nil,
      :paid_on => nil,
      :properties => nil,
      :metadata => nil,
      :invoice => nil
    }
  end
end
