module Paid
  class Event < APIResource
    class Data
      def self.construct(json={})
        return nil if json.nil?
        klass = APIClass.subclass_fetch(json[:object])
        klass.construct(json)
      end
    end

    # attributes :id and :object inherited from APIResource
    attribute :created_at
    attribute :type
    attribute :data, Data

    api_class_method :all, :get, :constructor => APIList.constructor(Event)
    api_class_method :retrieve, :get, ":path/:id", :arguments => [:id]


    def self.path
      "/v0/events"
    end

    APIClass.register_subclass(self, "event")
  end
end
