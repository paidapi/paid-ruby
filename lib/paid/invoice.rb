module Paid
  class Invoice < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Update
    include Paid::APIOperations::Create
  end
end
