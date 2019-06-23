# frozen_string_literal: true

module Tinder

  class Client
    class << self
      def feed(label)
        Feed.new(url: endpoint(:recommendations))
      end
    end
  end

  class Feed

    def initialize(url:)
      @url = url
    end

    def each(&block)
      response = Tinder::Client.get(@url)
      # "{\"meta\":{\"status\":429},\"error\":{\"message\":\"RATE_LIMITED\",\"code\":42901}}"

      fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
      fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'
      fail 'No Results Left' if response.dig('error', 'message') == 'There is no one around you'
      # The next one only occurs without Tinder Plus subscription
      results = response.dig('data', 'results')
      fail 'Out of likes' if results && results.first == 'You are out of likes today. Come back later to continue swiping on more people.'

      return results unless block_given?
      yield results
    end

  end
end
