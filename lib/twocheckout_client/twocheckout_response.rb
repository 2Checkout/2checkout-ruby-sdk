module TwocheckoutClient
  class TwocheckoutResponse
      attr_reader :data
      attr_reader :http_status

      def initialize(data, http_status = nil)
      @data = data
      @http_status = http_status
    end
  end
end
  