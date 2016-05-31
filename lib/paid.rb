# Paid Ruby bindings
# API spec at https://paid.com/docs/api
require 'cgi'
require 'set'
require 'openssl'
require 'rest_client'
require 'json'
require 'base64'

# Version
require 'paid/version'

# Errors
require 'paid/errors/paid_error'
require 'paid/errors/api_error'
require 'paid/errors/api_connection_error'
require 'paid/errors/authentication_error'

# Wrapper around RestClient
require 'paid/requester'

# Builders for creating API methods.
require 'paid/path_builder'
require 'paid/headers_builder'
require 'paid/params_builder'
require 'paid/api_method'

# Generic resources
require 'paid/api_resource'
require 'paid/api_list'
require 'paid/util'

# API specific resources
require 'paid/account'
require 'paid/customer'
require 'paid/event'
require 'paid/event_data'
require 'paid/invoice'
require 'paid/plan'
require 'paid/plan_item'
require 'paid/order'
require 'paid/order_item'
require 'paid/product'
require 'paid/subscription'
require 'paid/transaction'
require 'paid/refund_list'


module Paid
  @api_key = nil

  @api_base = "https://api.paidapi.com/v0"
  @api_staging = "https://api-staging.paidapi.com/v0"
  @auth_header = nil
  @api_version = "v0"
  @support_email = "support@paidapi.com"
  @docs_url = "https://paidapi.com/docs"


  class << self
    attr_accessor :api_key, :api_base, :api_version
    attr_reader :auth_header, :support_email, :docs_url, :api_staging
  end

end
