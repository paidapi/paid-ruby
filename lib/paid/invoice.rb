module Paid
  class Invoice < APIResource
    include Paid::APIOperations::List
    include Paid::APIOperations::Update
    include Paid::APIOperations::Create

    def issue(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      response, api_key = Paid.request(
        :post, issue_url, api_key || @api_key, params, headers)
      refresh_from(response, api_key)
    end

    private

    def issue_url
      url + '/issue'
    end
  end
end
