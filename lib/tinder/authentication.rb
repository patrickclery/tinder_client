# frozen_string_literal: true

module Tinder
  # This is a Concern for Client
  module Authentication

    # @param phone_number String
    def request_code(phone_number)
      response = post('auth/sms/send',
                      auth_type:    'sms',
                      phone_number: phone_number)

      fail UnexpectedResponse unless response.dig('meta', 'status') == 200 && response.dig('data','sms_sent')
      true
    end

    # @return String tinder token
    def validate(phone_number, confirmation_code)
      data = { otp_code:     confirmation_code,
               phone_number: phone_number,
               is_update:    false }

      response = post('auth/sms/send',
                      otp_code:     confirmation_code,
                      phone_number: phone_number,
                      auth_type:    'sms',
                      is_update:    false)

      response.dig('data', 'refresh_token') || fail(UnexpectedResponse)
    end

  end
end
