module Paid
  class Event < APIResource
    include Paid::APIOperations::List
  end
end
