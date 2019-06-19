require "tinder/version"
require "tinder/client"
require "json"

module Tinder
  class Error < StandardError; end
  class UnexpectedResponse < StandardError; end
  class ClientNotAuthenticated < StandardError; end
  # Your code goes here...
end
