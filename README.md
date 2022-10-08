2Checkout Ruby SDK
=====================

This is the current 2Checkout Ruby SDK providing developers with a simple set of bindings to the 2Checkout 6.0 REST API, IPN and Convert Plus Signature API.

To use, import into your Gemfile.

```ruby
gem "twocheckout_client", :git => "git://github.com/2Checkout/2checkout-ruby-sdk.git"
```


Example Rest API Usage
-----------------

*Example Usage:*

```ruby
client = TwocheckoutClient::Client.new(
  merchant_code: 'YOUR_MERCHANT_CODE',
  secret_word: 'YOUR_SECRET_WORD',
  secret_key: 'YOUR_SECRET_KEY'
)

begin
  result = client.api.request(:post, 'orders', {
    :Items => [
      {
        :Name => 'test',
        :Description => 'test',
        :IsDynamic => true,
        :Tangible => false,
        :PurchaseType => 'PRODUCT',
        :Quantity => 1,
        :Price => {
          :Amount => 1,
          :Type => 'CUSTOM'
        }
      }
    ],
    :BillingDetails => {
      :FirstName => 'John',
      :LastName => 'Doe',
      :Email => 'john.doe@avangate.com',
      :CountryCode => 'US',
      :Address1 => '123 Test St',
      :City => 'Columbus',
      :State => 'OH',
      :Zip => '43123'
    },
    :PaymentDetails => {
      :Type => 'TEST',
      :Currency => 'USD',
      :PaymentMethod => {
        :CardType => 'mastercard',
        :CardNumber => '5555555555554444',
        :CCID => '123',
        :ExpirationMonth => '10',
        :ExpirationYear => '2026',
        :HolderName => 'John Doe',
        :Vendor3DSReturnURL => 'www.success.com',
        :Vendor3DSCancelURL => 'www.success.com'
      }
    }
  })
rescue TwocheckoutClient::Error => e
  puts e.message
end
```


Example Convert Plus Signature Generation:
-----------------------

*Example Usage:*

```ruby
client = TwocheckoutClient::Client.new(
  merchant_code: 'YOUR_MERCHANT_CODE',
  secret_word: 'YOUR_SECRET_WORD',
  secret_key: 'YOUR_SECRET_KEY'
)

signature = client.signature.generate()
```


Example IPN Usage:
---------------------

*Example Usage:*

```ruby
require "sinatra"

post '/' do
  ipn_params = JSON.parse(request.body.read, symbolize_names: true)

  client = TwocheckoutClient::Client.new(
    merchant_code: 'YOUR_MERCHANT_CODE',
    secret_word: 'YOUR_SECRET_WORD',
    secret_key: 'YOUR_SECRET_KEY'
  )

  result = client.ipn.validate(ipn_params)
  if (result === true)
    client.ipn.response(ipn_params)
  end
end
```


Errors:
------------------

A TwocheckoutClient::Error will be thrown for any library related errors. It is best to catch these errors so that they can be gracefully handled in your application.

