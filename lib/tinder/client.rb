# frozen_string_literal: true
require 'faraday'
require 'singleton'

module Tinder

  class Client
    # Always prefer V2 endpoints as the API is less buggy than V1
    BASE_URI  = 'https://api.gotinder.com/v2'
    ENDPOINTS = {
      request_code: "#{BASE_URI}/auth/sms/send?auth_type=sms&locale=en",
      validate:     "#{BASE_URI}/auth/sms/validate?auth_type=sms&locale=en"
    }

    include Singleton

    class << self
      include Singleton

      attr_accessor :access_token

      def request(method, url, data)
        response = Faraday.send(method, url, data, headers)
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
        response.dig('data', 'sms_sent') || fail(UnexpectedResponse)
      end

      # @return String tinder token
      def validate(phone_number, confirmation_code)
        data = { otp_code:     confirmation_code,
                 phone_number: phone_number,
                 is_update:    false }

        response = post(ENDPOINTS[:validate], data)
        @access_token = response.dig('data', 'refresh_token') || fail(UnexpectedResponse)
      end

      private

      def headers
        {
          "app-version":  "1020352",
          "platform":     "web",
          "User-agent":   "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36",
          "X-Auth-Token": @access_token
        }
      end

    end
  end
end
