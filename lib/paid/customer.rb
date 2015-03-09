module Paid
  class Customer < APIResource
    # attributes :id and :object inherited from APIResource
    attribute :name
    attribute :email
    attribute :description
    attribute :external_id
    attribute :aliases, APIList
    attribute :phone
    attribute :address_line1
    attribute :address_line2
    attribute :address_city
    attribute :address_state
    attribute :address_zip
    attribute :allow_ach
    attribute :allow_wire
    attribute :allow_check
    attribute :allow_credit_card
    attribute :terms
    attribute :billing_type
    attribute :billing_cycle
    attribute :stripe_customer_id

    api_class_method :all, :get, :constructor => APIList.constructor(Customer)
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
    api_class_method :create, :post
    api_class_method :by_alias, :get, "/v0/aliases/:alias", :arguments => [:alias]
    api_class_method :by_external_id, :get, ":path/by_external_id/:external_id", :arguments => [:external_id]

    api_instance_method :save, :put, :default_params => :changed_attributes
    api_instance_method :generate_invoice, :post, ":path/generate_invoice", :constructor => Invoice

    api_instance_method :invoices, :get, Invoice.path, :default_params => :customer_id_hash, :constructor => APIList.constructor(Invoice)
    api_instance_method :transactions, :get, Transaction.path, :default_params => :customer_id_hash, :constructor => APIList.constructor(Transaction)

    def self.path
      "/v0/customers"
    end

    def customer_id_hash
      { :customer => self.id }
    end

    APIClass.register_subclass(self, "customer")
  end
end
