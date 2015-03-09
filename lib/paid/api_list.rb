module Paid
  class APIList < APIClass
    include Enumerable

    attribute :object
    attribute :data

    def [](k)
      data[k]
    end

    def []=(k, v)
      data[k]=v
    end

    def last
      data.last
    end

    def length
      data.length
    end

    def each(&blk)
      data.each(&blk)
    end

    def self.constructor(klass)
      lambda do |json|
        instance = self.new
        instance.json = json

        json.each do |k, v|
          if attribute_names.include?(k.to_sym)
            if k.to_sym == :data
              instance.send("#{k}=", v.map{ |i| klass.construct(i) })
            else
              instance.send("#{k}=", v)
            end
          end
        end
        instance.clear_changed_attributes
        instance
      end
    end
  end
end
