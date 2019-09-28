require 'dry-struct'
require 'dry-types'
require "json"
require "tinder/version"
require "tinder/client"
require "tinder/account_settings"
require 'tinder/get_recommended_users'
require 'tinder/get_updates'
require 'tinder/like'
require 'tinder/pass'

class Dry::Struct
  transform_keys(&:to_sym)
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

