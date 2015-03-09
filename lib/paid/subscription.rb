module Paid
  class Subscription < APIResource
    # attributes :id and :object inherited from APIResource
    attribute :created_at
    attribute :starts_on
    attribute :next_transaction_on
    attribute :plan, Plan
    attribute :customer
    attribute :started_at
    attribute :ended_at
    attribute :cancelled_at

    api_class_method :all, :get, :constructor => APIList.constructor(Subscription)
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]
    api_class_method :create, :post

    api_instance_method :cancel, :post, ":path/cancel"

    def self.path
      "/v0/subscriptions"
    end

    APIClass.register_subclass(self, "subscription")
  end
end
