module TwocheckoutClient
  class Client
    def initialize(merchant_code: nil, secret_word: nil, secret_key: nil, api_version: nil)
      @configuration = {
        merchant_code: merchant_code,
        secret_word: secret_word,
        secret_key: secret_key,
        api_version: api_version ||= '6.0'
      }
    end

    def api
      @api ||= TwocheckoutClient::Api.new(@configuration)
    end

    def order
      @order ||= TwocheckoutClient::Order.new(api)
    end

    def ipn
      @ipn ||= TwocheckoutClient::Ipn.new(@configuration)
    end

    def signature
      @signature ||= TwocheckoutClient::Signature.new(@configuration, api)
    end
  end
end