module Paid
  class Account < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :business_name
    attr_accessor :business_url
    attr_accessor :business_logo

    def self.retrieve(params={}, headers={})
      method = APIMethod.new(:get, "/account", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/account", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    # Everything below here is used behind the scenes.
    APIResource.register_api_subclass(self, "account")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :business_name => nil,
      :business_url => nil,
      :business_logo => nil
    }
  end
end
