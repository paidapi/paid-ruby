module Paid
  class Invoice < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :summary
    attr_accessor :chase_schedule
    attr_accessor :next_chase_on
    attr_accessor :customer
    attr_accessor :issued_at
    attr_accessor :terms
    attr_accessor :metadata
    attr_accessor :url

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/invoices", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/invoices/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/invoices", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/invoices/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/invoices/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def issue(params={}, headers={})
      method = APIMethod.new(:post, "/invoices/:id/issue", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def mark_as_paid(params={}, headers={})
      method = APIMethod.new(:post, "/invoices/:id/mark_as_paid", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def void(params={}, headers={})
      method = APIMethod.new(:post, "/invoices/:id/void", params, headers, self)
      self.refresh_from(method.execute, method)
    end


    APIResource.register_api_subclass(self, "invoice")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :summary => nil,
      :chase_schedule => nil,
      :next_chase_on => nil,
      :customer => nil,
      :issued_at => nil,
      :terms => nil,
      :metadata => nil,
      :url => nil
    }
  end
end
