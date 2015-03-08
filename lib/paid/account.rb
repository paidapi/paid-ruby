module Paid
  class Account < APISingleton
    # attribute :object inherited from APISingleton
    attribute :id
    attribute :business_name
    attribute :business_url
    attribute :business_logo

    api_class_method :retrieve, :get, ":path"

    def self.path
      "/v0/account"
    end

    APIClass.register_subclass(self, "account")
  end
end
