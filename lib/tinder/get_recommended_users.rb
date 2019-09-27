# frozen_string_literal: true

class Dry::Struct
  transform_keys(&:to_sym)
end

module Tinder

  class Client
    def get_recommended_users(&block)
      if block_given?
        yield get_recommended_users && return
      end

      data = get("https://api.gotinder.com/recs/core")

      fail 'Connection Timeout' unless data.dig('data', 'timeout').nil?

      error_message = data.dig('error', 'message')
      fail 'Rate Limited' if error_message == 'RATE_LIMITED'
      return [] if error_message == 'There is no one around you'
      fail 'Unknown Error' unless error_message.nil?

      results = Array(data.dig('data', 'results'))
      return [] if results.first.is_a?(String) && results.first == 'You are out of likes today. Come back later to continue swiping on more people.'

      JSON.parse(results.first).map { |user_data| RecommendedUser.new(user_data) }
    end
  end

  class RecommendedUser < Dry::Struct

    attribute :type, Dry::Types['string']
    attribute :user do
      attribute :_id, Dry::Types['string']
      attribute :bio, Dry::Types['string']
      attribute :birth_date, Dry::Types['string']
      attribute :name, Dry::Types['string']
      attribute :photos, Dry::Types['array'] do
        attribute :id, Dry::Types['string']
        attribute :crop_info do
          attribute :user do
            attribute :width_pct, Dry::Types['float']
            attribute :x_offset_pct, Dry::Types['float']
            attribute :height_pct, Dry::Types['float']
            attribute :y_offset_pct, Dry::Types['float']
          end
          attribute :algo do
            attribute :width_pct, Dry::Types['float']
            attribute :x_offset_pct, Dry::Types['float']
            attribute :height_pct, Dry::Types['float']
            attribute :y_offset_pct, Dry::Types['float']
          end
          attribute :processed_by_bullseye, Dry::Types['bool']
          attribute :user_customized, Dry::Types['bool']
          attribute :url, Dry::Types['string'].meta(omittable: true)
          attribute :processedFiles, Dry::Types['array'].meta(omittable: true)
          attribute :fileName, Dry::Types['string'].meta(omittable: true)
          attribute :extension, Dry::Types['string'].meta(omittable: true)
        end
      end
      attribute :gender, Dry::Types['integer']
      attribute :jobs, Dry::Types['array']
      attribute :schools, Dry::Types['array'] do
        attribute :name, Dry::Types['string']
      end
      attribute :is_traveling, Dry::Types['bool'].meta(omittable: true)
      attribute :hide_age, Dry::Types['bool'].meta(omittable: true)
      attribute :hide_distance, Dry::Types['bool'].meta(omittable: true)
    end
    attribute :facebook do
      attribute :common_connections, Dry::Types['array']
      attribute :connection_count, Dry::Types['integer']
      attribute :common_interests, Dry::Types['array']
    end
    attribute :spotify, Dry::Types['hash']
    attribute :distance_mi, Dry::Types['integer']
    attribute :content_hash, Dry::Types['string']
    attribute :s_number, Dry::Types['integer']
    attribute :teasers, Dry::Types['array'] do
      attribute :type, Dry::Types['string']
      attribute :string, Dry::Types['string']
    end
  end
end
