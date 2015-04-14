module Paid
  class RefundList < APIList
    attr_accessor :parent_id

    def initialize(json={}, api_method=nil, parent_id)
      @klass = Util.constantize(:Transaction)
      @parent_id = parent_id
      refresh_from(json, api_method)
    end

    def all(params={}, headers={})
      method = APIMethod.new(:get, "/transactions/:parent_id/refunds", params, headers, self)
      APIList.new(:Transaction, method.execute, method)
    end

    def create(params={}, headers={})
      method = APIMethod.new(:post, "/transactions/:parent_id/refunds", params, headers, self)
      Util.constantize(:Transaction).new(method.execute, method)
    end

    @api_attributes = {
      :data => { :readonly => true }
    }
  end
end
