module TwocheckoutClient
  class Ipn

    def initialize(config)
      @config = config
    end

    def validate(ipn_params)
      ipn_params_transformed = ipn_params.transform_keys(&:to_s)
      if ipn_params_transformed['HASH']
        result = ''
        ipn_params_transformed.each do |key, value|
          unless key === 'HASH' || key != key.upcase
            if value.is_a?(Array)
              value.each do |val|
                result += val.length.to_s + val.to_s
              end
            else
              result += value.length.to_s + value.to_s
            end
          end
        end
        ipn_params_transformed['HASH'] === hash(result)
      else
        raise ArgumentError.new("Missing one or more required params [HASH].")
      end
    end

    def response(ipn_params)
      ipn_params_transformed = ipn_params.transform_keys(&:to_s)
      if ipn_params_transformed['IPN_PID'] && ipn_params_transformed['IPN_PNAME'] && ipn_params_transformed['IPN_DATE']
        date = Time.now.utc.strftime("%F %T")
        result_string = ''
        [ipn_params_transformed['IPN_PID'].first, ipn_params_transformed['IPN_PNAME'].first, ipn_params_transformed['IPN_DATE'], date].each do |value|
          result_string << value.length.to_s + value.to_s
        end
        hash = hash(result_string)
        "<EPAYMENT>#{date}|#{hash}</EPAYMENT>"
      else
        raise ArgumentError.new("Missing one or more required params [IPN_PID, IPN_PNAME, IPN_DATE].")
      end
    end

    private

    def hash(data)
      OpenSSL::HMAC.hexdigest  OpenSSL::Digest.new('md5'), @config[:secret_key], data
    end
  end
end