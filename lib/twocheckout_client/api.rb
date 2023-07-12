module TwocheckoutClient
  class Api
    API_HOST = 'api.2checkout.com'.freeze

    def initialize(config)
      @config = config
    end

    def request(http_method, path, params = nil, headers = nil, host = API_HOST)
      if /api/.match(host)
        url = "/rest/#{@config[:api_version]}/#{path}/"
      else
        url = path
      end

      unless params.nil?
        data = params.to_json
      end
      http = create_connection(host)

      begin
        headers = build_headers if headers.nil?
        response = http.send_request(http_method.to_s.upcase, url, data, headers)
      rescue StandardError => e
        raise Error.new("Encountered the following error while connecting to 2Checkout: #{e.class.name}")
      ensure
        http.finish if http.started?
      end

      create_twocheckout_response(response)
    end

    private

    def create_twocheckout_response(response)
      begin
        result = response.body ? JSON.parse(response.body, symbolize_names: true) : {}
        handle_error_response(response.code, result) if response.code.to_i >= 400
        TwocheckoutResponse.new(result, response.code)
      rescue JSON::ParserError => e
        raise Error.new("Invalid API response received: #{response.body.inspect}", response.code)
      end
    end

    def create_connection(host)
      connection = Net::HTTP.new(host, 443)
      connection.open_timeout = 30
      connection.read_timeout = 60                           
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
      connection
    end

    def handle_error_response(http_status, result)
      if result[:error_code]
        message = result[:message]
        code = result[:error_code]
      elsif result[:Error]
        message = result[:message]
        code = result[:code]
      else
        message = "Unkown 2Checkout API Error"
        code = "API_ERROR"
      end
      raise Error.new(message, code, http_status)
    end

    def hmac(date)
      data = String(@config[:merchant_code].length) + @config[:merchant_code] + String(date.length) + date
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @config[:secret_key].encode("ASCII"), data)
    end

    def build_headers
      date = Time.now.utc.strftime("%F %T")
      hash = hmac(date)
      {
        'Content-Type' => "application/json",
        'Accept' => "application/json",
        'X-Avangate-Authentication' => 'code="' + @config[:merchant_code] + '" date="' + date + '" hash="' + hash + '" algo="sha256"' 
      }
    end
  end
end
