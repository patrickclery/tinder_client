module Tinder

  attr_accessor :active_user

  class Client

    # @return AccountSettings
    def account_settings

      response = get("https://api.gotinder.com/v2/meta")

      fail('Unexpected response') if response.dig('data').nil?

      AccountSettings.new(response['data'])
    end
  end

  class AccountSettings < Dry::Struct

    attribute :account do
      attribute :fireboarding, Dry::Types['bool']
      attribute :email_prompt_show_strict_opt_in, Dry::Types['bool']
      attribute :email_prompt_show_marketing_opt_in, Dry::Types['bool']
      attribute :email_prompt_required, Dry::Types['bool']
      attribute :email_prompt_dismissible, Dry::Types['bool']
    end
    attribute :boost do
      attribute :duration, Dry::Types['integer']
      attribute :enabled, Dry::Types['bool']
      attribute :intro_multiplier, Dry::Types['integer']
      attribute :use_new_copy, Dry::Types['bool']
    end
    attribute :super_boost do
      attribute :enabled, Dry::Types['bool']
      attribute :duration, Dry::Types['integer']
      attribute :intro_multiplier, Dry::Types['integer']
      attribute :peak_hours_start_h, Dry::Types['integer']
      attribute :peak_hours_start_m, Dry::Types['integer']
      attribute :peak_hours_duration, Dry::Types['integer']
      attribute :variant, Dry::Types['integer']
      attribute :members_only_text, Dry::Types['string']
      attribute :p1, Dry::Types['bool']
      attribute :entry_gold_home, Dry::Types['bool']
      attribute :entry_upgrade, Dry::Types['bool']
    end

  end

end
