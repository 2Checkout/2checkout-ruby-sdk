module TwocheckoutClient
  class Error < StandardError
    attr_reader :message
    attr_reader :code
    attr_reader :http_status

    def initialize(message, code = nil, http_status = nil)
      @message = message
      @code = code
      @http_status = http_status
    end
  end
end
