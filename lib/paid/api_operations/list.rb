module Paid
  module APIOperations
    module List
      module ClassMethods
        def all(filters={}, opts={})
          api_key, headers = Util.parse_opts(opts)
          response, api_key = Paid.request(:get, api_url, api_key, filters, headers)
          Util.convert_to_paid_object(response, api_key)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
