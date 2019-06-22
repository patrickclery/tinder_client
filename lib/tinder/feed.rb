# frozen_string_literal: true

module Tinder

  class Client
    class << self
      def feed(label)
        Feed.new(url: endpoint(:recommendations))
      end
    end
  end

  class Feed < Enumerator

    def initialize(url:)
      @url = url
    end

    def each(&block)
      if block_given?
        response = Tinder::Client.get(@url)
        # "{\"meta\":{\"status\":429},\"error\":{\"message\":\"RATE_LIMITED\",\"code\":42901}}"
        fail RateLimited if response.dig('error', 'message') == 'RATE_LIMITED'
        fail NoResultsLeft if response.dig('error', 'message') == 'There is no one around you'
        yield response.dig('data','results')
      else
        to_enum(:each)
      end
    end

  end
end
