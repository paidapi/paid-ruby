module Paid
  class Subscription < APIResource
    attr_reader :id
    attr_reader :object
    attr_reader :created_at
    attr_accessor :starts_on
    attr_accessor :next_transaction_on
    attr_accessor :plan
    attr_accessor :customer
    attr_accessor :started_at
    attr_accessor :ended_at
    attr_accessor :cancelled_at

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/subscriptions", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/subscriptions/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/subscriptions", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/subscriptions/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def cancel(params={}, headers={})
      method = APIMethod.new(:post, "/subscriptions/:id/cancel", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    APIResource.register_api_subclass(self, "subscription")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :created_at => { :readonly => true },
      :starts_on => nil,
      :next_transaction_on => nil,
      :plan => { :constructor => :Plan },
      :customer => nil,
      :started_at => nil,
      :ended_at => nil,
      :cancelled_at => nil
    }
  end
end
