module Paid
  class PlanItem < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :plan
    attr_accessor :product

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/plan_items", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/plan_items/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/plan_items", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/plan_items/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/plan_items/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end


    APIResource.register_api_subclass(self, "plan_item")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :plan => nil,
      :product => nil
    }
  end
end
