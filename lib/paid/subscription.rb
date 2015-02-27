module Paid
  class Subscription < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Create

    def cancel(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      response, api_key = Paid.request(
        :post, cancel_url, api_key || @api_key, params, headers)
      refresh_from(response, api_key)
    end

    private

    def cancel_url
      api_url + '/cancel'
    end
  end
end
