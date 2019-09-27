module Tinder

  class Client

    # This includes the matches, as well as the messages, so must be parsed
    # @return Boolean true on success

    def pass(person_id)
      response = get("https://api.gotinder.com/user/pass/#{person_id}")

      fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
      fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'

      true
    end
  end
end
