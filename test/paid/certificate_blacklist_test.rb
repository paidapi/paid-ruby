# require File.expand_path('../../test_helper', __FILE__)

# module Paid

#   class CertificateBlacklistTest < Test::Unit::TestCase
#     should "not trust revoked certificates" do
#       assert_raises(Paid::APIConnectionError) {
#         Paid::CertificateBlacklist.check_ssl_cert("https://revoked.paidapi.com:444",
#                                                     Paid::DEFAULT_CA_BUNDLE_PATH)
#       }
#     end

#     should "trust api.paidapi.com" do
#       assert_true Paid::CertificateBlacklist.check_ssl_cert("https://api.paidapi.com",
#                                                               Paid::DEFAULT_CA_BUNDLE_PATH)
#     end
#   end
# end
