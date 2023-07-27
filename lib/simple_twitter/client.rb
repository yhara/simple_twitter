module SimpleTwitter
  # Twitter API Client
  class Client
    # @param bearer_token [String] This requires for OAuth 2
    # @param api_key [String] API Key (a.k.a Consumer Key). This requires for OAuth 1.0a
    # @param api_secret_key [String] API Secret Key (a.k.a Consumer Secret). This requires for OAuth 1.0a
    # @param access_token [String] Access Token. This requires for OAuth 1.0a
    # @param access_token_secret [String] Access Token Secret. This requires for OAuth 1.0a
    #
    # @example Initialize with OAuth 2
    #   client = SimpleTwitter::Client.new(bearer_token: "bearer_token")
    #
    # @example Initialize with OAuth 1.0a
    #   client = SimpleTwitter::Client.new(
    #     api_key: "api_key",
    #     api_secret_key: "api_secret_key",
    #     access_token: "access_token",
    #     access_token_secret: "access_token_secret",
    #   )
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

    # @!method get(url, params: {}, json: {}, form: {})
    #   Call Twitter API with GET method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method get_raw(url, params: {}, json: {}, form: {})
    #   Call Twitter API with GET method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [HTTP::Response]
    #   @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation

    # @!method post(url, params: {}, json: {}, form: {})
    #   Call Twitter API with POST method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method post_raw(url, params: {}, json: {}, form: {})
    #   Call Twitter API with POST method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [HTTP::Response]
    #   @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation

    # @!method put(url, params: {}, json: {}, form: {})
    #   Call Twitter API with PUT method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method put_raw(url, params: {}, json: {}, form: {})
    #   Call Twitter API with PUT method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [HTTP::Response]
    #   @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation

    # @!method delete(url, params: {}, json: {}, form: {})
    #   Call Twitter API with DELETE method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [Hash] parsed json data
    #   @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    #   @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error

    # @!method delete_raw(url, params: {}, json: {}, form: {})
    #   Call Twitter API with DELETE method
    #   @param url [String]
    #   @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    #   @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    #   @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    #   @return [HTTP::Response]
    #   @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation

    %i[get post put delete].each do |m|
      class_eval <<~EOD
        def #{m}(url, params: {}, json: {}, form: {})
          res = #{m}_raw(url, params: params, json: json, form: form)
          parse_response(res)
        end

        def #{m}_raw(url, params: {}, json: {}, form: {})
          args = create_http_args(params: params, json: json, form: form)
          http(:#{m}, url, params).#{m}(url, args)
        end
      EOD
    end

    private

    # @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
    # @param json [Hash] Send this arg as JSON request body with `Content-Type: application/json` header
    # @param form [Hash] Send this arg as form-data request body with `Content-Type: multipart/form-data` header
    # @return [Hash<Symbol, Object>]
    def create_http_args(params:, json:, form:)
      args = {
        params: params,
        headers: {
          "User-Agent" => "simple_twitter v#{SimpleTwitter::VERSION} (https://github.com/yhara/simple_twitter)",
        },
      }
      args[:json] = json unless json.empty?
      args[:form] = form unless form.empty?
      args
    end

    # @param method [Symbol]
    # @param url [String]
    # @param params [Hash<Symbol, String>]
    # @return [HTTP::Client]
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
    # @return [Hash] parsed json data
    # @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
    # @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error
    # @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation
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
