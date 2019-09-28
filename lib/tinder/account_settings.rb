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
      attribute :is_email_verified, Dry::Types['bool']
      attribute :account_email, Dry::Types['string']
      attribute :account_phone_number, Dry::Types['string']
    end
    attribute :boost do
      attribute :duration, Dry::Types['integer']
      attribute :allotment, Dry::Types['integer']
      attribute :allotment_used, Dry::Types['integer']
      attribute :allotment_remaining, Dry::Types['integer']
      attribute :internal_remaining, Dry::Types['integer']
      attribute :purchased_remaining, Dry::Types['integer']
      attribute :remaining, Dry::Types['integer']
      attribute :super_boost_purchased_remaining, Dry::Types['integer']
      attribute :super_boost_remaining, Dry::Types['integer']
      attribute :boost_refresh_amount, Dry::Types['integer']
      attribute :boost_refresh_interval, Dry::Types['integer']
      attribute :boost_refresh_interval_unit, Dry::Types['string']
    end
    attribute :email_settings do
      attribute :email, Dry::Types['string']
      attribute :email_settings do
        attribute :promotions, Dry::Types['bool']
        attribute :messages, Dry::Types['bool']
        attribute :new_matches, Dry::Types['bool']
      end
    end
    attribute :instagram do
      attribute :username, Dry::Types['string']
      attribute :profile_picture, Dry::Types['string']
      attribute :media_count, Dry::Types['integer']
      attribute :last_fetch_time, Dry::Types['string']
      attribute :completed_initial_fetch, Dry::Types['bool']
      attribute :photos, Dry::Types['array']
      attribute :should_reauthenticate, Dry::Types['bool']
    end
    attribute :likes do
      attribute :likes_remaining, Dry::Types['integer']
    end
    attribute :notifications, Dry::Types['array']
    attribute :plus_control do
      attribute :discoverable_party, Dry::Types['string']
      attribute :hide_ads, Dry::Types['bool']
      attribute :hide_age, Dry::Types['bool']
      attribute :hide_distance, Dry::Types['bool']
      attribute :blend, Dry::Types['string']
    end
    attribute :products, Dry::Types['hash']
    attribute :purchase, Dry::Types['hash']
    attribute :spotify, Dry::Types['hash']
    attribute :super_likes do
      attribute :remaining, Dry::Types['integer']
      attribute :alc_remaining, Dry::Types['integer']
      attribute :new_alc_remaining, Dry::Types['integer']
      attribute :allotment, Dry::Types['integer']
      attribute :superlike_refresh_amount, Dry::Types['integer']
      attribute :superlike_refresh_interval, Dry::Types['integer']
      attribute :superlike_refresh_interval_unit, Dry::Types['string']
      attribute :resets_at, Dry::Types['string']
    end
    attribute :tinder_u do
      attribute :status, Dry::Types['string']
    end
    attribute :travel do
      attribute :is_traveling, Dry::Types['bool']
    end
    attribute :tutorials, Dry::Types['array']
    attribute :user do
      attribute :_id, Dry::Types['string']
      attribute :age_filter_max, Dry::Types['integer']
      attribute :age_filter_min, Dry::Types['integer']
      attribute :bio, Dry::Types['string']
      attribute :birth_date, Dry::Types['string']
      attribute :create_date, Dry::Types['string']
      attribute :crm_id, Dry::Types['string']
      attribute :discoverable, Dry::Types['bool']
      attribute :distance_filter, Dry::Types['integer']
      attribute :gender, Dry::Types['integer']
      attribute :gender_filter, Dry::Types['integer']
      attribute :name, Dry::Types['string']
      attribute :photos, Dry::Types['array']
    end
  end

end
