require_relative 'test_helper'

module TwocheckoutClient

  class ApiTest < Test::Unit::TestCase

    def test_api
      begin
        result = TCO_TEST_CLIENT.api.request(:post, 'orders', TEST_ORDER_PAYLOAD)
        assert_not_nil( result.data )
      rescue TwocheckoutClient::Error => e
        assert_equal( "AUTHENTICATION_ERROR", e.code )
      end
    end
  end
end
