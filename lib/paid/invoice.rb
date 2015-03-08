module Paid
  class Invoice < APIResource
    # attributes :id and :object inherited from APIResource
    attribute :summary
    attribute :chase_schedule
    attribute :next_chase_on
    attribute :customer
    attribute :issued_at
    attribute :terms
    attribute :url

    api_class_method :all, :get, :constructor => APIList.constructor(Invoice)
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
    api_class_method :create, :post

    api_instance_method :issue, :post, ":path/issue"
    api_instance_method :mark_as_paid, :post, ":path/mark_as_paid" # requires :via in params


    def self.path
      "/v0/invoices"
    end

    APIClass.register_subclass(self, "invoice")
  end
end
