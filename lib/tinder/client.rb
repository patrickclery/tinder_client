# frozen_string_literal: true
require 'faraday'
require 'singleton'

module Tinder

  class Client
    # Always prefer V2 endpoints as the API is less buggy than V1
    BASE_URI  = 'https://api.gotinder.com/v2'
    ENDPOINTS = {
      request_code: "#{BASE_URI}/auth/sms/send?auth_type=sms&locale=en",
      login:        "https://api.gotinder.com/v2/auth/login/sms?locale=en",
      validate:     "#{BASE_URI}/auth/sms/validate?auth_type=sms&locale=en",
    }

    include Singleton

    class << self
      include Singleton

      attr_accessor :api_token
      attr_accessor :refresh_token

      def request(method, url, data)
        response = Faraday.send(method, url, JSON.generate(data), headers)
        JSON.parse(response.body)
      end

      def post(url, **data)
        request(:post, url, data)
      end

      def get(url, **data)
        request(:get, url, data)
      end

      # @param phone_number String
      def request_code(phone_number)
        response = post(ENDPOINTS[:request_code], phone_number: phone_number)
        response.dig('data', 'sms_sent') || fail(UnexpectedResponse(response))
      end

      # @return String tinder token
      def validate(phone_number, confirmation_code)
        data = { otp_code:     confirmation_code,
                 phone_number: phone_number,
                 is_update:    false }

        response      = post(ENDPOINTS[:validate], data)
        @refresh_token = response.dig('data', 'refresh_token') || fail(UnexpectedResponse(response))
      end

      def login(phone_number, refresh_token)
        data     = { refresh_token: refresh_token, phone_number: phone_number }
        response = post(ENDPOINTS[:login], data)

        @api_token   = response.dig('data', 'api_token') || fail(UnexpectedResponse(response))
        @id          = response['data']['_id']
        @is_new_user = response['data']['is_new_user']
        @api_token
      end

      def endpoint(action)
        ENDPOINTS[action]
      end

      private

      def headers
        {
          'app_version':  '6.9.4',
          'platform':     'ios',
          "content-type": "application/json",
          "User-agent":   "Tinder/7.5.3 (iPhone; iOS 10.3.2; Scale/2.00)",
          "Accept":       "application/json",
          "X-Auth-Token": @api_token
        }
      end

    end
  end
end
