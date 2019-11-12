require "tinder_client"
require "rspec"
require 'webmock/rspec'
require 'hashdiff' # Fix for webmock
require_relative 'default'
# ### FOR DEVELOPERS:
#
# You can make use of my spec stubs by requiring them in your in your spec
# helper: require the file `tinder_client/spec/contexts/http_request_stubs.rb`
# in your $APP/spec/spec_helper.rb, then call the client as you would normally
# and the requests will be stubbed.
RSpec.shared_context 'http request stubs' do
  include_context 'default'
  # These values relate to the fixtures in spec/fixtures
  let!(:updates) { JSON.parse(File.read(File.join(__dir__, "../fixtures/updates.json"))) }
  let!(:recommendations_1) { JSON.parse(File.read(File.join(__dir__, "../fixtures/recommendations_1.json"))) }

  before do
    ### Authentication
    stub_request(:post, "https://api.gotinder.com/v2/auth/sms/send?auth_type=sms")
      .with(body: { phone_number: phone_number })
      .to_return(body: { "meta": { "status": 200 },
                         "data": { "otp_length": 6,
                                   "sms_sent":   true } }.to_json)

    stub_request(:post, "https://api.gotinder.com/v2/auth/sms/validate?auth_type=sms")
      .with(body: { phone_number: phone_number,
                    is_update:    false,
                    otp_code:     confirmation_code })
      .to_return(body: { "meta": { "status": 200 },
                         "data": { "refresh_token": refresh_token,
                                   "validated":     true } }.to_json)

    stub_request(:post, "https://api.gotinder.com/v2/auth/login/sms")
      .with(body: { phone_number:  phone_number,
                    refresh_token: refresh_token })
      .to_return(body: { "meta": { "status": 200 },
                         "data": { "_id":           id,
                                   "api_token":     api_token,
                                   "refresh_token": refresh_token,
                                   "is_new_user":   false } }.to_json)

    # Simulate when retrieving 3 packs of 4 recommended users, then running out of results
    json_response = JSON.generate({ "meta": { "status": 200 },
                                    "data": { "results": recommendations_1 } })

    stub_request(:get, "https://api.gotinder.com/v2/recs/core")
      .to_return(headers: { "Content-Type" => "application/json" },
                 body:    json_response).then
      .to_return(headers: { "Content-Type" => "application/json" },
                 body:    json_response).then
      .to_return(headers: { "Content-Type" => "application/json" },
                 body:    json_response).then
      .to_return(headers: { "Content-Type" => "application/json" },
                 body:    JSON.generate({ "error": { "message": "There is no one around you" } }))

    # Updates (inbox, matches, etc. - everything on the dashboard)
    stub_request(:post, "https://api.gotinder.com/updates")
      .to_return(body: updates.to_json, headers: { "Content-Type" => "application/json" })

    stub_request(:get, "https://api.gotinder.com/v2/profile?include=account,boost,email_settings,instagram,likes,notifications,plus_control,products,purchase,spotify,super_likes,tinder_u,travel,tutorials,user")
      .to_return(body: File.read(File.join(__dir__, "../fixtures/profile.json")))
  end
end
