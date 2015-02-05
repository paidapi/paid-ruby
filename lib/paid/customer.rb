module Paid
  class Customer < APIResource
    include Paid::APIOperations::Create
    include Paid::APIOperations::Delete
    include Paid::APIOperations::Update
    include Paid::APIOperations::List

    def generate_invoice(params={}, opts={})
      api_key, headers = Util.parse_opts(opts)
      response, api_key = Paid.request(
        :post, generate_invoice_url, api_key || @api_key, params, headers)
      # refresh_from(response, api_key)
      refresh_from({ :invoice => response }, api_key, true)
      invoice
    end

    def invoices
      Invoice.all({ :customer => id }, @api_key)
    end

    def transactions
      Transaction.all({ :customer => id }, @api_key)
    end

    private

    def generate_invoice_url
      api_url + '/generate_invoice'
    end
  end
end
