require 'timecop'
require_relative 'test_helper'

module TwocheckoutClient
  class SignatureTest < Test::Unit::TestCase
    def test_signature
      begin
        result = TCO_TEST_CLIENT.signature.generate(TEST_CONVERT_PLUS_PARAMS)
        assert_not_nil( result.data[:signature] )
      rescue TwocheckoutClient::Error => e
        assert_equal( "401", e.code )
      end
    end
  end
end