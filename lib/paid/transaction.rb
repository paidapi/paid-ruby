module Paid
  class Transaction < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Create
    include Paid::APIOperations::Update
  end
end
