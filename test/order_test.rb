require_relative 'test_helper'

module TwocheckoutClient
  class OrderTest < Test::Unit::TestCase
    def test_order_create
      begin
        result = TCO_TEST_CLIENT.order.create(TEST_ORDER_PAYLOAD)
        assert_not_nil( result.data )
      rescue TwocheckoutClient::Error => e
        assert_equal( "AUTHENTICATION_ERROR", e.code )
      end
    end

    def test_order_get
      begin
        result = TCO_TEST_CLIENT.order.get('164108357')
        assert_not_nil( result.data )
      rescue TwocheckoutClient::Error => e
        assert_equal( "AUTHENTICATION_ERROR", e.code )
      end
    end
  end
end
