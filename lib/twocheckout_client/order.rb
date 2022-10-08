require_relative "resource"

module TwocheckoutClient
  class Order < Resource
    def create(params)
      @api.request(:post, 'orders', params)
    end

    def get(ref_no)
      @api.request(:get, "orders/#{ref_no}/")
    end
  end
end
