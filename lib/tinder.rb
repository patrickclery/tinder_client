require "tinder/version"
require "tinder/client"
require "json"

module Tinder

  class UnexpectedResponse < StandardError
    def initialize(response)
      @response = response
    end

    def message
      "The response was: #{response}"
    end
  end

  class ClientNotAuthenticated < StandardError;
  end

end

