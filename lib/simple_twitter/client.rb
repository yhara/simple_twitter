module SimpleTwitter
  # Twitter API Client
  class Client
    # @param bearer_token [String] This requires for API v2
    # @param api_key [String] This requires for API v1.1
    # @param api_secret_key [String] This requires for API v1.1
    # @param access_token [String] This requires for API v1.1
    # @param access_token_secret [String] This requires for API v1.1
    def initialize(bearer_token: nil,
                   api_key: nil,
                   api_secret_key: nil,
                   access_token: nil,
                   access_token_secret: nil)
      if bearer_token
        @bearer_token = bearer_token
      else
        @oauth_params = {
          consumer_key: api_key,
          consumer_secret: api_secret_key,
          token: access_token,
          token_secret: access_token_secret,
        }
      end
    end

    # @!method get(url, params: {}, json: nil)
    #   Call Twitter API with GET method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method get_raw(url, params: {}, json: nil)
    #   Call Twitter API with GET method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [HTTP::Response]

    # @!method post(url, params: {}, json: nil)
    #   Call Twitter API with POST method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method post_raw(url, params: {}, json: nil)
    #   Call Twitter API with POST method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [HTTP::Response]

    # @!method put(url, params: {}, json: nil)
    #   Call Twitter API with PUT method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method put_raw(url, params: {}, json: nil)
    #   Call Twitter API with PUT method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [HTTP::Response]

    # @!method delete(url, params: {}, json: nil)
    #   Call Twitter API with DELETE method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method delete_raw(url, params: {}, json: nil)
    #   Call Twitter API with DELETE method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @return [HTTP::Response]

    %i[get post put delete].each do |m|
      class_eval <<~EOD
        def #{m}(url, params: {}, json: nil)
          res = #{m}_raw(url, params: params, json: json)
          parse_response(res)
        end

        def #{m}_raw(url, params: {}, json: nil)
          args = { params: params }
          args[:json] = json if json
          http(:#{m}, url, params).#{m}(url, args)
        end
      EOD
    end

    private

    # @param method [Symbol]
    # @param url [String]
    # @param params [Hash<Symbol, String>]
    # @return [HTTP::Request]
    def http(method, url, params)
      HTTP.auth(auth_header(method, url, params))
    end

    # @param method [Symbol]
    # @param url [String]
    # @param params [Hash<Symbol, String>]
    # @return [String]
    def auth_header(method, url, params)
      if @bearer_token
        "Bearer #{@bearer_token}"
      else
        SimpleOAuth::Header.new(method, url, params, @oauth_params).to_s
      end
    end

    # @param res [HTTP::Response]
    # @return [Object] parsed json data
    # @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    # @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error
    def parse_response(res)
      case res.code.to_i / 100
      when 4
        raise ClientError, res
      when 5
        raise ServerError, res
      end

      JSON.parse(res.to_s, symbolize_names: true)
    end
  end
end
