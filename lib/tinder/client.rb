# frozen_string_literal: true
require 'faraday'
require 'singleton'

module Tinder

  class Client
    # Always prefer V2 endpoints as the API is less buggy than V1
    BASE_URI = 'https://api.gotinder.com/v2'

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
    include Singleton

    class << self
      include Singleton

      attr_accessor :access_token

      def request(action, method, **data)
        http         = Faraday.new(url: endpoint(action))
        http.params  = { lang: 'en' }.merge(data)
        http.headers = { user_agent: USER_AGENT }
        response     = http.send(method)
        JSON.parse(response.body)
      end

      def post(action, data = nil)
        request(action, :post, data)
      end

      def get(action, data = nil)
        request(action, :get, data)
      end

      def endpoint(action, data = {})
        "#{BASE_URI}/#{action}"
      end

      # @param phone_number String
      def request_code(phone_number)
        response = post('auth/sms/send',
                        auth_type:    'sms',
                        phone_number: phone_number)

        fail UnexpectedResponse unless response.dig('meta', 'status') == 200 && response.dig('data', 'sms_sent')
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

        @access_token = response.dig('data', 'refresh_token') || fail(UnexpectedResponse)
      end

      private

      def headers
        {
          'app_version':  '6.9.4',
          'platform':     'ios',
          "content-type": "application/json",
          "User-agent":   "Tinder/7.5.3 (iPhone; iOS 10.3.2; Scale/2.00)",
          "X-Auth-Token": @access_token
        }
      end

    end
  end
end
