require 'http'
require 'simple_oauth'

module SimpleTwitter
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
        def #{m}(url, params={})
          JSON.parse(#{m}_raw(url, params).to_s, symbolize_names: true)
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
  end
end
