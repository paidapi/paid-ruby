module Paid
  module APIOperations
    module Update
      def save(opts={})
        values = serialize_params(self).merge(opts)

        if @values[:properties]
          values[:properties] = serialize_properties
        end

        if values.length > 0
          values.delete(:id)

          response, api_key = Paid.request(:post, api_url, @api_key, values)
          refresh_from(response, api_key)
        end
        self
      end

      def serialize_properties
        if @unsaved_values.include?(:properties)
          # the properties object has been reassigned
          # i.e. as object.properties = {key => val}
          properties_update = @values[:properties]  # new hash
          new_keys = properties_update.keys.map(&:to_sym)
          # remove keys at the server, but not known locally
          keys_to_unset = @previous_properties.keys - new_keys
          keys_to_unset.each {|key| properties_update[key] = ''}

          properties_update
        else
          # properties is a PaidObject, and can be serialized normally
          serialize_params(@values[:properties])
        end
      end

      def serialize_params(obj)
        case obj
        when nil
          ''
        when PaidObject
          unsaved_keys = obj.instance_variable_get(:@unsaved_values)
          obj_values = obj.instance_variable_get(:@values)
          update_hash = {}

          unsaved_keys.each do |k|
            update_hash[k] = serialize_params(obj_values[k])
          end

          update_hash
        else
          obj
        end
      end
    end
  end
end
