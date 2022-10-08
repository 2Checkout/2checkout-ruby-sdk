require 'jwt'

module TwocheckoutClient
    class Signature
      CONVERT_PLUS_HOST = 'secure.2checkout.com'.freeze

      def initialize(config, api)
        @config = config
        @api = api
      end
  
      def generate(params, ttl = 3600000)
        signature_jwt = jwt(ttl)
        headers = build_headers(signature_jwt)
        @api.request(:post, '/checkout/api/encrypt/generate/signature/', params, headers, CONVERT_PLUS_HOST)
      end

      def jwt(ttl = 3600000)
        iat = Time.now.to_i
        exp = iat + ttl
        payload = {sub: @config[:merchant_code], iat: iat, exp: exp}
        JWT.encode payload, @config[:secret_word], 'HS512'
      end

      private

      def build_headers(signature_jwt)
        {
          'Content-Type' => "application/json",
          'Accept' => "application/json",
          'merchant-token' => signature_jwt
        }
      end
    end
  end