require 'dry-struct'
class Dry::Struct
  transform_keys(&:to_sym)
end

require 'dry-types'
require "json"
require 'faraday'
require 'tinder/client'
require 'tinder/profile'
require 'tinder/account_settings'
require 'tinder/get_recommended_users'
require 'tinder/get_updates'
require 'tinder/profile'
require 'tinder/like'
require 'tinder/pass'

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

