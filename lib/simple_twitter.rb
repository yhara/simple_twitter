require 'http'
require 'simple_oauth'

module SimpleTwitter
  class Error < StandardError
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
        # @return [Object] parsed json data
        # @raise [SimpleTwitter::ClientError] Twitter API returned 4xx error
        # @raise [SimpleTwitter::ServerError] Twitter API returned 5xx error
        def #{m}(url, params={})
          res = #{m}_raw(url, params)
          parse_response(res)
        end

        # @return [HTTP::Response]
        def #{m}_raw(url, params={})
          http(:#{m}, url, params).#{m}(url, params: params)
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
        raise ClientError, res.to_s
      when 5
        raise ServerError, res.to_s
      end

      JSON.parse(res.to_s, symbolize_names: true)
    end
  end
end
