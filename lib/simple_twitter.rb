require 'http'
require 'simple_oauth'

require_relative "simple_twitter/version"

module SimpleTwitter
  autoload :Client,      "simple_twitter/client"
  autoload :ClientError, "simple_twitter/client_error"
  autoload :Error,       "simple_twitter/error"
  autoload :ServerError, "simple_twitter/server_error"
end
