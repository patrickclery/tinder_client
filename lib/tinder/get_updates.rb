module Tinder

  class Client
    # This includes the matches, as well as the messages, so must be parsed
    def get_updates(since = Time.now)
      response = get("https://api.gotinder.com/updates")

      fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
      fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'
      # The next one only occurs without Tinder Plus subscription
      fail 'No Results Left' if response.dig('error', 'message') == 'There is no one around you'

      updates = Updates.new(response)
    end
  end

  class Updates < Dry::Struct

    attribute :blocks, Dry::Types['array'].of(Dry::Types['string'])
    attribute :deleted_lists, Dry::Types['array']
    attribute :goingout, Dry::Types['array']
    attribute :harassing_messages, Dry::Types['array']
    attribute :inbox, Dry::Types['array'] do
      attribute :_id, Dry::Types['string']
      attribute :match_id, Dry::Types['string']
      attribute :sent_date, Dry::Types['string']
      attribute :message, Dry::Types['string']
      attribute :to, Dry::Types['string']
      attribute :from, Dry::Types['string']
      attribute :created_date, Dry::Types['string']
      attribute :timestamp, Dry::Types['coercible.string']
    end
    attribute :poll_interval, Dry::Types['hash']
    attribute :liked_messages, Dry::Types['array'] do
      attribute :message_id, Dry::Types['string']
      attribute :updated_at, Dry::Types['string']
      attribute :liker_id, Dry::Types['string']
      attribute :match_id, Dry::Types['string']
      attribute :is_liked, Dry::Types['bool']
    end
    attribute :lists, Dry::Types['array']
    attribute :matches, Dry::Types['array'] do
      attribute :_id, Dry::Types['string']
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
      attribute :messages, Dry::Types['array'] do
        attribute :_id, Dry::Types['string']
        attribute :match_id, Dry::Types['string']
        attribute :sent_date, Dry::Types['string']
        attribute :message, Dry::Types['string']
        attribute :to, Dry::Types['string']
        attribute :from, Dry::Types['string']
        attribute :created_date, Dry::Types['string']
        attribute :timestamp, Dry::Types['coercible.string']
      end
      attribute :muted, Dry::Types['bool']
      attribute :participants, Dry::Types['array']
      attribute :pending, Dry::Types['bool']
      attribute :person do
        attribute :bio, Dry::Types['string'].meta(omittable: true)
        attribute :birth_date, Dry::Types['string']
        attribute :gender, Dry::Types['integer']
        attribute :name, Dry::Types['string']
        attribute :ping_time, Dry::Types['string']
        attribute :photos, Dry::Types['array']
      end
      attribute :readreceipt, Dry::Types['hash']
      attribute :seen, Dry::Types['hash']
    end
    attribute :squads, Dry::Types['array']

  end
end

