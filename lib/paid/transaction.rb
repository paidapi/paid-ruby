module Paid
  class Transaction < APIResource
    # attributes :id and :object inherited from APIResource
    attribute :amount
    attribute :description
    attribute :customer
    attribute :paid
    attribute :paid_on
    attribute :properties
    attribute :invoice

    api_class_method :create, :post
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
    api_class_method :all, :get, :constructor => APIList.constructor(Transaction)

    api_instance_method :save, :put, :default_params => changed_lambda
    api_instance_method :mark_as_paid, :post, ":path/mark_as_paid"


    def self.path
      "/v0/transactions"
    end

    APIClass.register_subclass(self, "transaction")
  end
end
