# frozen_string_literal: true

module Tinder

  class Client
    include Singleton
    include Authentication
    # Always prefer V2 endpoints as the API is less buggy than V1
    BASE_URI = 'https://api.gotinder.com/v2'

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'

    class << self

      def request(action, method, *data)
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

      private

      def headers(access_token)
        {
          'app_version':  '6.9.4',
          'platform':     'ios',
          "content-type": "application/json",
          "User-agent":   "Tinder/7.5.3 (iPhone; iOS 10.3.2; Scale/2.00)",
          "X-Auth-Token": access_token
        }
      end

      def endpoint(action, data = {})
        "#{BASE_URI}#{action}"
      end

    end
  end
end
