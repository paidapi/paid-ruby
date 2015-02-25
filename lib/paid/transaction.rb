module Paid
  class Transaction < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Create
    include Paid::APIOperations::Update

    def mark_as_paid(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      response, api_key = Paid.request(
        :post, mark_as_paid_url, api_key || @api_key, params, headers)
      refresh_from(response, api_key)
    end

    private

    def mark_as_paid_url
      api_url + '/mark_as_paid'
    end
  end
end
