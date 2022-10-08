require 'timecop'
require_relative 'test_helper'

module TwocheckoutClient
  class IpnTest < Test::Unit::TestCase

    def test_validate
      result = TCO_TEST_CLIENT.ipn.validate(TEST_IPN)
      assert_true( result )
    end

    def test_response
      new_time = Time.utc(2021, 9, 1, 12, 0, 0)
      Timecop.freeze(new_time)
      date = Time.now.utc.strftime("%F %T")

      result = TCO_TEST_CLIENT.ipn.response(TEST_IPN)
      Timecop.return
      assert_equal( "<EPAYMENT>#{date}|8de1f4e08c08ddf9b620aa0a30a74e01</EPAYMENT>", result )
    end
  end
end