module Paid
  class Plan < APIResource

    # attributes :id and :object inherited from APIResource
    attribute :name
    attribute :description
    attribute :interval
    attribute :interval_count
    attribute :amount
    attribute :created_at

    api_class_method :all, :get, :constructor => APIList.constructor(Plan)
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
    api_class_method :create, :post

    def self.path
      "/v0/plans"
    end

    APIClass.register_subclass(self, "plan")
  end
end
