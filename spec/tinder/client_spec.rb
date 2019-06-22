require 'rspec'
require 'webmock'

RSpec.describe Tinder::Client do
  include WebMock::API

  subject { described_class }

  let(:id) { "1a234a56123ab12345123456" }
  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let(:refresh_token) { "xxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }
  let(:confirmation_code) { "123456" }
  let(:phone_number) { "1234567890" }

  it { should be_a_kind_of(Singleton) }
  it { should respond_to(:endpoint).with(1).argument }
  it { should respond_to(:feed).with(1).argument }
  it { should respond_to(:get).with(1).arguments }
  it { should respond_to(:post).with(1).arguments }
  it { should respond_to(:request_code).with(1).argument }
  it { should respond_to(:validate).with(2).arguments }

  before do
    stub_request(:post, "https://api.gotinder.com/v2/auth/sms/send?auth_type=sms")
      .with(body: { phone_number: phone_number })
      .to_return(body: { "meta": { "status": 200 }, "data": { "otp_length": 6, "sms_sent": true } }.to_json
      )

    stub_request(:post, "https://api.gotinder.com/v2/auth/sms/validate?auth_type=sms")
      .with(
        body: {
          phone_number: phone_number,
          is_update:    false,
          otp_code:     confirmation_code
        })
      .to_return(body: { "meta": { "status": 200 }, "data": { "refresh_token": refresh_token, "validated": true } }.to_json)

    stub_request(:post, "https://api.gotinder.com/v2/auth/login/sms")
      .with(
        body: {
          phone_number:  phone_number,
          refresh_token: refresh_token
        })
      .to_return(body: { "meta": { "status": 200 }, "data": { "_id": id, "api_token": api_token, "refresh_token": refresh_token, "is_new_user": false } }.to_json)

  end

  it 'can login via phone number and confirmation code' do
    expect(subject.request_code(phone_number)).to be true
    expect(subject.validate(phone_number, confirmation_code)).to eq refresh_token
    expect(subject.refresh_token).to eq(refresh_token)
    expect(subject.login(phone_number, refresh_token)).to eq api_token
    expect(subject.api_token).to eq(api_token)
  end

end
