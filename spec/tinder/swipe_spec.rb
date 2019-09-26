RSpec.describe Tinder::Client do
  include WebMock::API

  subject { described_class }

  let!(:client) { Tinder::Client }

  it { should respond_to(:profile) }
  it { should respond_to(:profile).with(1).argument }

  context 'User logged in' do

    let(:api_token) { "eyJhbGciOiJIUzI1NiJ9.MTc3ODk5MDk4MDM.5q4R0H08rE0Dd9KgxMPp6jcTfIBLCXgEuVZfC9znJTE" }

    before do
      client.api_token = access_token

      stub_request(:post, "https://api.gotinder.com/v2/profile")
        .with(body: { phone_number: phone_number })
        .to_return(body: { "meta": { "status": 200 }, "data": { "otp_length": 6, "sms_sent": true } }.to_json
        )

      stub_request(:post, "https://api.gotinder.com/profile")
        .with(
          body: {
            phone_number: phone_number,
            is_update:    false,
            otp_code:     confirmation_code
          })
        .to_return(body: { "meta": { "status": 200 }, "data": { "refresh_token": access_token, "validated": true } }.to_json)
    end

    it 'can fetch the active profile' do
      expect(subject.profile).to be_a(Hash)
    end

  end

end
