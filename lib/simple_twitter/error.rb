module SimpleTwitter
  # Error base class
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
end
