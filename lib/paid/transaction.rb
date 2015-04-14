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
    attr_accessor :invoice
    attr_accessor :refunds

    def refresh_from(json={}, api_method=nil)
      super(json, api_method)
      json = { :id => json } unless json.is_a?(Hash)
      @refunds = RefundList.new(json[:refunds], nil, id)
    end

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

    def mark_as_paid(params={}, headers={})
      method = APIMethod.new(:post, "/transactions/:id/mark_as_paid", params, headers, self)
      self.refresh_from(method.execute, method)
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
      :invoice => nil,
      :refunds => { :constructor => :RefundList, :provide_parent => true }
    }
  end
end
