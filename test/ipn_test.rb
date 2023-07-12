require 'timecop'
require_relative 'test_helper'

module TwocheckoutClient
  class IpnTest < Test::Unit::TestCase

    def test_validate_sha3
      params = TEST_IPN.clone
      result = TCO_TEST_CLIENT.ipn.validate(params)
      assert_true( result )
    end

    def test_validate_sha256
      params = TEST_IPN.clone
      params.delete(:SIGNATURE_SHA3_256)
      result = TCO_TEST_CLIENT.ipn.validate(params)
      assert_true( result )
    end

    def test_validate_md5
      params = TEST_IPN.clone
      params.delete(:SIGNATURE_SHA3_256)
      params.delete(:SIGNATURE_SHA2_256)
      result = TCO_TEST_CLIENT.ipn.validate(params)
      assert_true( result )
    end

    def test_response_sha3
      new_time = Time.utc(2021, 9, 1, 12, 0, 0)
      Timecop.freeze(new_time)
      date = Time.now.utc.strftime("%F %T")

      params = TEST_IPN.clone

      result = TCO_TEST_CLIENT.ipn.response(params)
      Timecop.return
      assert_equal( "<sig algo=\"sha3-256\" date=\"#{date}\">be4a3c11fdd302f92c32067f8f579f917f506394ccec263faefee9c12babb697</sig>", result )
    end

    def test_response_sha256
      new_time = Time.utc(2021, 9, 1, 12, 0, 0)
      Timecop.freeze(new_time)
      date = Time.now.utc.strftime("%F %T")

      params = TEST_IPN.clone
      params.delete(:SIGNATURE_SHA3_256)

      result = TCO_TEST_CLIENT.ipn.response(params)
      Timecop.return
      assert_equal( "<sig algo=\"sha256\" date=\"#{date}\">835fa8385fadca06262596669ecf59a1294099bbe831974a002ecd26f34da6d6</sig>", result )
    end

    def test_response_md5
      new_time = Time.utc(2021, 9, 1, 12, 0, 0)
      Timecop.freeze(new_time)
      date = Time.now.utc.strftime("%F %T")

      params = TEST_IPN.clone
      params.delete(:SIGNATURE_SHA3_256)
      params.delete(:SIGNATURE_SHA2_256)

      result = TCO_TEST_CLIENT.ipn.response(params)
      Timecop.return
      assert_equal( "<EPAYMENT>#{date}|32f82d191c3fad5ddfc6883ef9413093</EPAYMENT>", result )
    end
  end
end