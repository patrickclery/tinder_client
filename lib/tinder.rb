require "tinder/version"
require "tinder/client"
require "json"
require 'dry-struct'
require 'dry-types'
require 'tinder'
require 'tinder/get_recommended_users'
require 'tinder/get_updates'

module Types
  include Dry.Types
end

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

