# frozen_string_literal: true
require 'dry-struct'
require 'dry-types'

class Dry::Struct
  transform_keys(&:to_sym)
end

class Hash
  def keys_to_sym
    Hash[self.map { |(k, v)| [k.to_sym, v] }]
  end
end

module Tinder

  class Client
    class << self
      # This includes the matches, as well as the messages, so must be parsed
      def updates(since = Time.now)
        response = get("https://api.gotinder.com/updates")

        fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
        fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'
        # The next one only occurs without Tinder Plus subscription
        fail 'No Results Left' if response.dig('error', 'message') == 'There is no one around you'

        updates = Updates.new(response)
      end
    end
  end

  # This is a decorator for the hash object of each match
  class Match < Dry::Struct
    attribute :_id, Dry::Types['string'] # This is not always the same as :id
    attribute :closed, Dry::Types['bool']
    attribute :common_friend_count, Dry::Types['integer']
    attribute :common_like_count, Dry::Types['integer']
    attribute :created_date, Dry::Types['string']
    attribute :dead, Dry::Types['bool']
    attribute :following, Dry::Types['bool']
    attribute :following_moments, Dry::Types['bool']
    attribute :id, Dry::Types['string']
    attribute :is_boost_match, Dry::Types['bool']
    attribute :is_fast_match, Dry::Types['bool']
    attribute :is_super_like, Dry::Types['bool']
    attribute :last_activity_date, Dry::Types['string']
    attribute :message_count, Dry::Types['integer']
    attribute :messages, Dry::Types['array']
    attribute :muted, Dry::Types['bool']
    attribute :participants, Dry::Types['array']
    attribute :pending, Dry::Types['bool']
    attribute :person do
      attribute :bio, Dry::Types['coercible.string']
                        .meta(omittable: true)
      attribute :birth_date, Dry::Types['string']
      attribute :gender, Dry::Types['integer']
      attribute :name, Dry::Types['string']
      attribute :ping_time, Dry::Types['string']
      attribute :photos, Dry::Types['array']
    end
    attribute :readreceipt, Dry::Types['hash']
    attribute :seen, Dry::Types['hash']
  end

  class Updates

    attr_reader :matches

    # @param response Array This payload contains all kinds of data used to populate the UI
    def initialize(response)
      @matches = parse_matches(response['matches'])
    end

    private

    def parse_matches(matches)
      matches.map do |data|
        Match.new(**data.keys_to_sym)
      end
    end

    def parse
      if match['person'].nil?
        # It's a message from the active user to someone
        first     = match['messages'].first
        tinder_id = (first['from'] == @id ? first['to'] : first['from'])
      else
        tinder_id = match['person']['_id']
      end
    end

  end
end

