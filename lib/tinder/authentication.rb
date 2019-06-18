# frozen_string_literal: true

module Tinder
  module Authentication

    # @param phone_number String
    def request_code(phone_number)
      response = post(endpoint('auth/sms/send'),
                      auth_type:    'sms',
                      phone_number: phone_number)

      fail UnexpectedResponse unless response['meta']['status'] == 200 && response['data']['sms_sent']
    end

    # @return String tinder token
    def validate(phone_number, confirmation_code)
      data = { otp_code:     confirmation_code,
               phone_number: phone_number,
               is_update:    false }

      response = post(endpoint('auth/sms/validate'),
                      otp_code:     confirmation_code,
                      phone_number: phone_number,
                      auth_type:    'sms',
                      is_update:    false)

      response.dig('data', 'refresh_token') || fail(UnexpectedResponse)
    end

  end
end
