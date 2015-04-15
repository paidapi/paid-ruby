module Paid
  class EventData

    def self.construct(json={})
      return nil if json.nil?
      return APIResource.api_subclass_fetch(json[:object]).new(json)
    end

  end
end
