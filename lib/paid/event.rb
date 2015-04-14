module Paid
  class Event < APIResource
    attr_reader :id
    attr_reader :object
    attr_reader :created_at
    attr_reader :type
    attr_reader :data

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/events", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/events/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/events/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    # Everything below here is used behind the scenes.
    APIResource.register_api_subclass(self, "event")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :created_at => { :readonly => true },
      :type => { :readonly => true },
      :data => { :constructor => :EventData, :readonly => true },
    }
  end
end
