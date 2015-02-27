module Paid
  class Plan < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Create
  end
end
