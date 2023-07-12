module TwocheckoutClient
  class Ipn

    def initialize(config)
      @config = config
    end

    def validate(ipn_params)
      ipn_params_transformed = ipn_params.transform_keys(&:to_s)
      result = ''
      ipn_params_transformed.each do |key, value|
        unless ['HASH', 'SIGNATURE_SHA3_256', 'SIGNATURE_SHA2_256'].include? key
          unless key != key.upcase
            if value.is_a?(Array)
              value.each do |val|
                result += val.length.to_s + val.to_s
              end
            else
              result += value.length.to_s + value.to_s
            end
          end
        end
      end

      algorithm = get_algorithm(ipn_params_transformed)
      get_compare_hash(algorithm, ipn_params_transformed) === hash(result, algorithm)
    end

    def response(ipn_params)
      ipn_params_transformed = ipn_params.transform_keys(&:to_s)
      algorithm = get_algorithm(ipn_params_transformed)
      if ipn_params_transformed['IPN_PID'] && ipn_params_transformed['IPN_PNAME'] && ipn_params_transformed['IPN_DATE']
        date = Time.now.utc.strftime("%F %T")
        result_string = ''
        [ipn_params_transformed['IPN_PID'].first, ipn_params_transformed['IPN_PNAME'].first, ipn_params_transformed['IPN_DATE'], date].each do |value|
          result_string << value.length.to_s + value.to_s
        end
        signature = hash(result_string, algorithm)
        format_response(algorithm, date, signature)
      else
        raise ArgumentError.new("Missing one or more required params [IPN_PID, IPN_PNAME, IPN_DATE].")
      end
    end

    private

    def hash(data, algorithm)
      OpenSSL::HMAC.hexdigest  OpenSSL::Digest.new(algorithm), @config[:secret_key], data
    end

    def get_algorithm(params)
      if (params["SIGNATURE_SHA3_256"])
        'sha3-256'
      elsif (params["SIGNATURE_SHA2_256"])
        'sha256'
      else
        'md5'
      end
    end

    def get_compare_hash(algorithm, params)
        case algorithm
        when "sha3-256"
          params['SIGNATURE_SHA3_256'];
        when "sha256"
          params['SIGNATURE_SHA2_256'];
        else
          params['HASH']
        end
    end

    def format_response(algorithm, date, signature)
      if algorithm == "md5"
        "<EPAYMENT>#{date}|#{signature}</EPAYMENT>"
      else
        "<sig algo=\"#{algorithm}\" date=\"#{date}\">#{signature}</sig>"
      end
    end
  end
end