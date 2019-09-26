# frozen_string_literal: true

require 'tinder/client'

module Tinder

  class Client

    # This includes the matches, as well as the messages, so must be parsed
    # @return Boolean true on success

    def self.like_someone(person_id, api_token)
      response = get("https://api.gotinder.com/user/like/#{person_id}")

      fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
      fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'

      true
    end
  end
end
