module Paid
  module ParamsBuilder

    def self.clean(params)
      Util.symbolize_keys(params || {})
    end

    # Clean the params, and the hash to_merge, and then merge them.
    # This ensures that we dont get something like { "id" => 123, :id => 321 }.
    def self.merge(params, to_merge)
      params = clean(params)
      to_merge = clean(to_merge)
      params.merge(to_merge)
    end

    def self.build(params, api_key=nil, auth_key=nil)
      clean(params)
    end

  end
end





