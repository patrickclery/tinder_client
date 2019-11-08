module Tinder

  attr_accessor :active_user

  class Client

    # @return ActiveProfile
    def profile

      data = { include: "account,boost,email_settings,instagram," \
                        "likes,notifications,plus_control,products," \
                        "purchase,spotify,super_likes,tinder_u,"\
                        "travel,tutorials,user" }

      response = get("https://api.gotinder.com/v2/profile", data)

      fail('Unexpected response') if response.dig('data').nil?

      ActiveProfile.new(response['data'])
    end
  end

  class ActiveProfile < Dry::Struct

    attribute :account do
      attribute :is_email_verified, Types.bool
      attribute :account_email, Types.string
      attribute :account_phone_number, Types.string
    end
    attribute :boost do
      attribute :duration, Types.integer
      attribute :allotment, Types.integer
      attribute :allotment_used, Types.integer
      attribute :allotment_remaining, Types.integer
      attribute :internal_remaining, Types.integer
      attribute :purchased_remaining, Types.integer
      attribute :remaining, Types.integer
      attribute :super_boost_purchased_remaining, Types.integer
      attribute? :super_boost_remaining, Types.integer.optional # renamed to remaining
      attribute :remaining, Types.integer.optional
      attribute :boost_refresh_amount, Types.integer
      attribute :boost_refresh_interval, Types.integer
      attribute :boost_refresh_interval_unit, Types.string
    end
    attribute :email_settings do
      attribute :email, Types.string
      attribute :email_settings do
        attribute :promotions, Types.bool
        attribute :messages, Types.bool
        attribute :new_matches, Types.bool
      end
    end
    attribute :instagram do
      attribute :username, Types.string
      attribute :profile_picture, Types.string
      attribute :media_count, Types.integer
      attribute :last_fetch_time, Types.string
      attribute :completed_initial_fetch, Types.bool
      attribute :photos, Types.array
      attribute :should_reauthenticate, Types.bool
    end
    attribute :likes do
      attribute :likes_remaining, Types.integer
    end
    attribute :notifications, Types.array
    attribute :plus_control do
      attribute :discoverable_party, Types.string
      attribute :hide_ads, Types.bool
      attribute :hide_age, Types.bool
      attribute :hide_distance, Types.bool
      attribute :blend, Types.string
    end
    attribute :products, Types.hash
    attribute :purchase, Types.hash
    attribute :spotify, Types.hash
    attribute :super_likes do
      attribute :remaining, Types.integer
      attribute :alc_remaining, Types.integer
      attribute :new_alc_remaining, Types.integer
      attribute :allotment, Types.integer
      attribute :superlike_refresh_amount, Types.integer
      attribute :superlike_refresh_interval, Types.integer
      attribute :superlike_refresh_interval_unit, Types.string
      attribute :resets_at, Types.string
    end
    attribute :tinder_u do
      attribute :status, Types.string
    end
    attribute :travel do
      attribute :is_traveling, Types.bool
    end
    attribute :tutorials, Types.array
    attribute :user do
      attribute :_id, Types.string
      attribute :age_filter_max, Types.integer
      attribute :age_filter_min, Types.integer
      attribute :bio, Types.string
      attribute :birth_date, Types.string
      attribute :create_date, Types.string
      attribute :crm_id, Types.string
      attribute :discoverable, Types.bool
      attribute :distance_filter, Types.integer
      attribute :gender, Types.integer
      attribute :gender_filter, Types.integer
      attribute :name, Types.string
      attribute :photos, Types.array
    end
  end

end
