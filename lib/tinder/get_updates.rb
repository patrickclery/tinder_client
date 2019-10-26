module Tinder
  class Client
    # This includes the matches, as well as the messages, so must be parsed
    # @return Updates a Dry::Struct object based on a JSON response

    def get_updates(since: Time.now)
      response = post(endpoint(:updates))

      fail 'Connection Timeout' unless response.dig('data', 'timeout').nil?
      fail 'Rate Limited' if response.dig('error', 'message') == 'RATE_LIMITED'
      # The next one only occurs without Tinder Plus subscription
      fail 'No Results Left' if response.dig('error', 'message') == 'There is no one around you'

      updates = Updates.new(response)
    end
  end

  class Message < Dry::Struct
    attribute :_id, Types.string
    attribute :match_id, Types.string
    attribute :sent_date, Types.string
    attribute :message, Types.string
    attribute :to, Types.string
    attribute :from, Types.string
    attribute :created_date, Types.string
    attribute :timestamp, Types.send('coercible.string')
  end

  class LikedMessage < Dry::Struct
    attribute :message_id, Types.string
    attribute :updated_at, Types.string
    attribute :liker_id, Types.string
    attribute :match_id, Types.string
    attribute :is_liked, Types.bool
  end

  class Person < Dry::Struct
    attribute? :bio, Types.string
    attribute :birth_date, Types.string
    attribute :gender, Types.integer
    attribute :name, Types.string
    attribute :ping_time, Types.string
    attribute :photos, Types.array
  end

  class Match < Dry::Struct
    attribute :_id, Types.string
    attribute :closed, Types.bool
    attribute :common_friend_count, Types.integer
    attribute :common_like_count, Types.integer
    attribute :created_date, Types.string
    attribute :dead, Types.bool
    attribute :following, Types.bool
    attribute :following_moments, Types.bool
    attribute :id, Types.string
    attribute :is_boost_match, Types.bool
    attribute :is_fast_match, Types.bool
    attribute :is_super_like, Types.bool
    attribute :last_activity_date, Types.string
    attribute :message_count, Types.integer
    attribute :messages, Types.array.of(Message)
    attribute :muted, Types.bool
    attribute :participants, Types.array
    attribute :pending, Types.bool
    attribute :person, Person
    attribute :readreceipt, Types.hash
    attribute :seen, Types.hash
  end

  class Updates < Dry::Struct
    attribute :blocks, Types.array.of(Types.string)
    attribute :deleted_lists, Types.array
    attribute :goingout, Types.array
    attribute :harassing_messages, Types.array
    attribute :inbox, Types.array.of(Message)
    attribute :poll_interval, Types.hash
    attribute :liked_messages, Types.array.of(LikedMessage)
    attribute :lists, Types.array
    attribute :matches, Types.array.of(Match)
    attribute :squads, Types.array
  end
end

