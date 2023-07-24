module SimpleTwitter
  # Error base class
  class Error < StandardError
    # @!attribute [r] raw_response
    # @return [HTTP::Response] raw error response
    # @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation
    attr_reader :raw_response

    # @!attribute [r] body
    # @return [Hash<Symbol, String>] error response body
    attr_reader :body

    # @param raw_response [HTTP::Response] raw error response from Twitter API
    # @see https://www.rubydoc.info/github/httprb/http/HTTP/Response HTTP::Response documentation
    def initialize(raw_response)
      @raw_response = raw_response

      begin
        @body = JSON.parse(raw_response.to_s, symbolize_names: true)

        title = @body[:title] || "Unknown error"
        title << " (status #{raw_response.code})"

        super(title)
      rescue JSON::ParserError => e
        # Twitter doesn't returns json
        super("Unknown error (status #{raw_response.code})")
      end
    end
  end
end
