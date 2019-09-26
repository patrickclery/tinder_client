require "tinder/version"
require "tinder/client"
require "json"

require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types
end

require 'tinder'
require 'tinder/get_recommended_users'
require 'tinder/get_updates'

module Tinder

  class UnexpectedResponse < StandardError
  end

  class RateLimited < StandardError;
  end
  class ClientNotAuthenticated < StandardError;
  end
  class ConnectionTimeout < StandardError;
  end
  class NoResultsLeft < StandardError;
  end
  class OutOfLikes < StandardError;
  end

end

