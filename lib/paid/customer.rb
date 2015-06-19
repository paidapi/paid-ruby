module Paid
  class Customer < APIResource
    attr_reader :id
    attr_reader :object
    attr_accessor :name
    attr_accessor :email
    attr_accessor :description
    attr_accessor :external_id
    attr_accessor :phone
    attr_accessor :address_line1
    attr_accessor :address_line2
    attr_accessor :address_city
    attr_accessor :address_state
    attr_accessor :address_zip
    attr_accessor :address_country
    attr_accessor :allow_ach
    attr_accessor :allow_wire
    attr_accessor :allow_check
    attr_accessor :allow_credit_card
    attr_accessor :auto_generate
    attr_accessor :auto_issue
    attr_accessor :terms
    attr_accessor :billing_type
    attr_accessor :billing_cycle
    attr_accessor :stripe_customer_id

    def self.all(params={}, headers={})
      method = APIMethod.new(:get, "/customers", params, headers, self)
      APIList.new(self, method.execute, method)
    end

    def self.retrieve(id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :id => id
      })
      method = APIMethod.new(:get, "/customers/:id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.by_external_id(external_id, params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :external_id => external_id
      })
      method = APIMethod.new(:get, "/customers/by_external_id", params, headers, self)
      self.new(method.execute, method)
    end

    def self.create(params={}, headers={})
      method = APIMethod.new(:post, "/customers", params, headers, self)
      self.new(method.execute, method)
    end

    def refresh(params={}, headers={})
      method = APIMethod.new(:get, "/customers/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def save(params={}, headers={})
      params = ParamsBuilder.merge(params, changed_api_attributes)
      method = APIMethod.new(:put, "/customers/:id", params, headers, self)
      self.refresh_from(method.execute, method)
    end

    def generate_invoice(params={}, headers={})
      method = APIMethod.new(:post, "/customers/:id/generate_invoice", params, headers, self)
      Util.constantize(:Invoice).new(method.execute, method)
    end

    def invoices(params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :customer => self.id,
      })
      method = APIMethod.new(:get, "/invoices", params, headers, self)
      APIList.new(:Invoice, method.execute, method)
    end

    def transactions(params={}, headers={})
      params = ParamsBuilder.merge(params, {
        :customer => self.id,
      })
      method = APIMethod.new(:get, "/transactions", params, headers, self)
      APIList.new(:Transaction, method.execute, method)
    end


    # Everything below here is used behind the scenes.
    APIResource.register_api_subclass(self, "customer")
    @api_attributes = {
      :id => { :readonly => true },
      :object => { :readonly => true },
      :name => nil,
      :email => nil,
      :description => nil,
      :external_id => nil,
      :phone => nil,
      :address_line1 => nil,
      :address_line2 => nil,
      :address_city => nil,
      :address_state => nil,
      :address_zip => nil,
      :address_country => nil,
      :allow_ach => nil,
      :allow_wire => nil,
      :allow_check => nil,
      :allow_credit_card => nil,
      :auto_generate => nil,
      :auto_issue => nil,
      :terms => nil,
      :billing_type => nil,
      :billing_cycle => nil,
      :stripe_customer_id => nil
    }
  end
end
