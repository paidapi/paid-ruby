module Paid
  class Plan < APIResource
    attr_reader :id
    attr_reader :object
    attr_reader :created_at
    attr_accessor :name
    attr_accessor :description
    attr_accessor :interval
    attr_accessor :interval_count
    attr_accessor :amount

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/plans", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/plans/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/plans", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/plans/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    APIResource.register_api_subclass(self, "plan")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :created_at => { :readonly => true },
      :name => nil,
      :description => nil,
      :interval => nil,
      :interval_count => nil,
      :amount => nil,
    }
  end
end
