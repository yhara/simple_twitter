require 'http'
require 'simple_oauth'

module SimpleTwitter
  class Error < StandardError
    # @!attribute [r] raw_response
    # @return [HTTP::Response] raw error response
    attr_reader :raw_response

    # @!attribute [r] body
    # @return [Hash<Symbol, String>] error response body
    attr_reader :body

    # @param raw_response [HTTP::Response] raw error response from Twitter API
    def initialize(raw_response)
      @raw_response = raw_response
      @body = JSON.parse(raw_response.to_s, symbolize_names: true)

      title = @body[:title] || "Unknown error"
      title << " (status #{raw_response.code})"

      super(title)
    end
  end

  class ClientError < Error
  end

  class ServerError < Error
  end

  class Client
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

    %i[get post put delete].each do |m|
      class_eval <<~EOD
        # @param params [Hash] Send this arg as a query string. (e.g. `?name1=value1&name2=value2`)
        # @param json [Hash] Send this arg as JSON request body with "Content-Type: application/json" header
        # @return [Object] parsed json data
        # @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
        # @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error
        def #{m}(url, params: {}, json: nil)
          res = #{m}_raw(url, params, json)
          parse_response(res)
        end

        # @return [HTTP::Response]
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
