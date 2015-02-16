module Paid
  class Alias < APIResource
    include Paid::APIOperations::Update

    def self.retrieve(id, api_key=nil)
      customer_alias = super(id, api_key)
      instance = Paid::Customer.new(customer_alias.id, api_key)
      instance.refresh
      instance
    end
  end
end
