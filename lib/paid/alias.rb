module Paid
  class Alias < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Create
  end
end
