module Tinder

  class Client
    def get_recommendations(&block)
      if block_given?
        yield get_recommendations && return
      end

      data = get(endpoint(:recommendations))

      fail 'Connection Timeout' unless data.dig('data', 'timeout').nil?

      error_message = data.dig('error', 'message')
      fail 'Rate Limited' if error_message == 'RATE_LIMITED'
      return [] if error_message == 'There is no one around you'
      fail 'Unknown Error' unless error_message.nil?

      results = Array(data.dig('data', 'results'))
      return [] if results.first.is_a?(String) && results.first == 'You are out of likes today. Come back later to continue swiping on more people.'

      results.map { |user_data| Recommendation.new(user_data) }
    end

    alias_method :recommendations, :get_recommendations
  end

  class PhotoMetadata < Dry::Struct
    attribute :width_pct, Dry::Types['coercible.integer']
    attribute :x_offset_pct, Dry::Types['coercible.integer']
    attribute :height_pct, Dry::Types['coercible.integer']
    attribute :y_offset_pct, Dry::Types['coercible.integer']
  end

  class Photo < Dry::Struct
    attribute :id, Types.string
    attribute? :crop_info do
      attribute? :user, PhotoMetadata
      attribute? :algo, PhotoMetadata
      attribute? :processed_by_bullseye, Types.bool
      attribute? :user_customized, Types.bool
      attribute? :url, Types.string
      attribute? :processedFiles, Types.array
      attribute? :fileName, Types.string
      attribute? :extension, Types.string
    end
  end

  class User < Dry::Struct
    attribute :_id, Types.string
    attribute :bio, Types.string
    attribute :birth_date, Types.string
    attribute :name, Types.string
    attribute? :photos, Types.array.of(Photo)
    attribute? :gender, Types.integer
    attribute? :jobs, Types.array
    attribute? :schools, Types.array do
      attribute? :name, Types.string
    end
    attribute? :city do
      attribute? :name, Types.string
    end
    attribute? :is_traveling, Types.bool
    attribute? :hide_age, Types.bool
    attribute? :hide_distance, Types.bool
  end

  # Return this object
  class Recommendation < Dry::Struct
    attribute :type, Types.string
    attribute :user, User
    attribute? :facebook do
      attribute? :common_connections, Types.array
      attribute? :connection_count, Types.integer
      attribute? :common_interests, Types.array
    end
    attribute? :spotify, Types.hash
    attribute? :distance_mi, Types.integer
    attribute? :content_hash, Types.string
    attribute? :s_number, Types.integer
    attribute? :teasers, Types.array do
      attribute? :type, Types.string
      attribute? :string, Types.string
    end
  end
end
