module Paid
  class Customer < APIResource
    include Paid::APIOperations::Create
    include Paid::APIOperations::Delete
    include Paid::APIOperations::Update
    include Paid::APIOperations::List

    def invoices
      Invoice.all({ :customer => id }, @api_key)
    end

    def transactions
      Transaction.all({ :customer => id }, @api_key)
    end
  end
end
