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
    attribute :client_resources do
      attribute :rate_card do
        attribute :carousel, Dry::Types['array'].of(Dry::Types['hash'])
      end
      attribute :plus_screen, Dry::Types['array']
    end
    attribute :account do
      attribute :fireboarding, Dry::Types['bool']
      attribute :email_prompt_show_strict_opt_in, Dry::Types['bool']
      attribute :email_prompt_show_marketing_opt_in, Dry::Types['bool']
      attribute :email_prompt_required, Dry::Types['bool']
      attribute :email_prompt_dismissible, Dry::Types['bool']
    end
    attribute :boost do
      attribute :enabled, Dry::Types['bool']
      attribute :duration, Dry::Types['integer']
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
    attribute :sexual_orientations do
      attribute :enabled, Dry::Types['bool']
      attribute :orientations, Dry::Types['array'].of(Dry::Types['hash'])
      attribute :excluded_orientations, Dry::Types['array'].of(Dry::Types['string'])
    end
    attribute :credit_card do
      attribute :variant, Dry::Types['integer']
      attribute :price_tos_on_top, Dry::Types['bool']
    end
    attribute :readreceipts do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :fast_match do
      attribute :enabled, Dry::Types['bool']
      attribute :preview_minimum_time, Dry::Types['integer']
      attribute :notif_options, Dry::Types['array'].of(Dry::Types['integer'])
      attribute :notif_defaults, Dry::Types['integer']
      attribute :new_count_fetch_interval, Dry::Types['integer']
      attribute :boost_new_count_fetch_interval, Dry::Types['integer']
      attribute :new_count_threshold, Dry::Types['integer']
      attribute :polling_mode, Dry::Types['integer']
      attribute :entry_point, Dry::Types['bool']
      attribute :controlla_optimization, Dry::Types['bool']
      attribute :use_teaser_endpoint, Dry::Types['bool']
    end
    attribute :gold_homepage do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :top_picks do
      attribute :enabled, Dry::Types['bool']
      attribute :local_daily_enabled, Dry::Types['bool']
      attribute :local_daily_msg, Dry::Types['string']
      attribute :local_daily_offsets do
        attribute :offset0, Dry::Types['integer']
        attribute :offset1, Dry::Types['integer']
        attribute :offset2, Dry::Types['integer']
        attribute :offset3, Dry::Types['integer']
      end
      attribute :free_daily, Dry::Types['bool']
      attribute :num_free_rated_limit, Dry::Types['integer']
      attribute :refresh_interval, Dry::Types['integer']
      attribute :lookahead, Dry::Types['integer']
      attribute :post_swipe_paywall, Dry::Types['bool']
    end
    attribute :intro_pricing do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :paywall do
      attribute :full_price, Dry::Types['bool']
      attribute :e1, Dry::Types['bool']
      attribute :e2, Dry::Types['bool']
      attribute :bouncer_avatar, Dry::Types['bool']
      attribute :pbls, Dry::Types['bool']
      attribute :show_likes_count_in_bouncer, Dry::Types['bool']
      attribute :e3, Dry::Types['integer']
      attribute :e4, Dry::Types['integer']
    end
    attribute :merchandising do
      attribute :gold_v1_enabled, Dry::Types['bool']
      attribute :gold_v2_enabled, Dry::Types['bool']
      attribute :gamepad_counter_variant, Dry::Types['string']
    end
    attribute :purchase do
      attribute :new_google_purchase, Dry::Types['bool']
      attribute :new_cc_purchase, Dry::Types['bool']
    end
    attribute :recs do
      attribute :card_replay, Dry::Types['bool']
    end
    attribute :tinder_plus do
      attribute :enabled, Dry::Types['bool']
      attribute :discount, Dry::Types['bool']
    end
    attribute :subscription do
      attribute :renewal_banner_title, Dry::Types['string']
      attribute :renewal_banner_gold_body, Dry::Types['string']
      attribute :renewal_banner_plus_body, Dry::Types['string']
    end
    attribute :super_like do
      attribute :enabled, Dry::Types['bool']
      attribute :alc_mode, Dry::Types['integer']
    end
    attribute :profile do
      attribute :can_edit_jobs, Dry::Types['bool']
      attribute :can_edit_schools, Dry::Types['bool']
      attribute :can_edit_email, Dry::Types['bool']
      attribute :can_add_photos_from_facebook, Dry::Types['bool']
      attribute :can_show_common_connections, Dry::Types['bool']
      attribute :school_name_max_length, Dry::Types['integer']
      attribute :job_title_max_length, Dry::Types['integer']
      attribute :company_name_max_length, Dry::Types['integer']
    end
    attribute :select do
      attribute :enabled, Dry::Types['bool']
      attribute :recs_enabled, Dry::Types['bool']
      attribute :invited, Dry::Types['bool']
    end
    attribute :feedback do
      attribute :rate_app, Dry::Types['bool']
    end
    attribute :typing_indicator do
      attribute :typing_heartbeat, Dry::Types['integer']
      attribute :typing_ttl, Dry::Types['integer']
    end
    attribute :places do
      attribute :available, Dry::Types['bool']
      attribute :places_ui, Dry::Types['string']
    end
    attribute :terms_of_service do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :swipe_surge do
      attribute :enabled, Dry::Types['bool']
      attribute :in_swipe_surge, Dry::Types['bool']
    end
    attribute :traveling, Dry::Types['hash']
    attribute :crm_inbox do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :background_location do
      attribute :enabled, Dry::Types['bool']
    end
    attribute :levers, Dry::Types['hash']
  end

end
