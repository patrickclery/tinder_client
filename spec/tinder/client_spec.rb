require 'rspec'
require 'webmock'

RSpec.describe Tinder::Client do
  include WebMock::API

  subject { described_class }

  it { should respond_to(:request) }
  it { should respond_to(:get) }
  it { should respond_to(:post) }

  # Authentication concern
  context 'Authentication' do

    let(:access_token) { "eyJhbGciOiJIUzI1NiJ9.MTc3ODk5MDk4MDM.5q4R0H08rE0Dd9KgxMPp6jcTfIBLCXgEuVZfC9znJTE" }
    let(:confirmation_code) { "123456" }
    let(:phone_number) { "1234567890" }

    before do
      stub_request(:post, "https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&lang=en&phone_number=#{phone_number}")
        .to_return(body: { "meta": { "status": 200 }, "data": { "otp_length": 6, "sms_sent": true } }.to_json
        )

      stub_request(:post, "https://api.gotinder.com/v2/https://api.gotinder.com/v2/auth/sms/validate?auth_type=sms&is_update=false&lang=en&otp_code=#{confirmation_code}&phone_number=#{phone_number}")
        .to_return(body: { "meta": { "status": 200 }, "data": { "refresh_token": access_token, "validated": true } }.to_json)
    end

    it { should respond_to(:request_code).with(1).argument }
    it { should respond_to(:validate).with(2).arguments }

    it 'can request an SMS code to be sent' do
      response = subject.request_code('1234567890')
      expect(response).to be true
    end

    it 'can validate with an SMS code that was sent' do
      response = subject.validate('1234567890', confirmation_code)
      expect(response).to eq access_token
    end
  end

end
