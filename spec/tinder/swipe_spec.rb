RSpec.describe Tinder::Client do
  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let(:confirmation_code) { "123456" }
  let(:phone_number) { "1234567890" }

  it { should respond_to(:like) }
  it { should respond_to(:pass) }

  context 'User logged in' do

    before do
      subject.api_token = api_token

      stub_request(:post, "https://api.gotinder.com/v2/profile")
        .with(body: { phone_number: phone_number })
        .to_return(body: { "meta": { "status": 200 }, "data": { "otp_length": 6, "sms_sent": true } }.to_json)

      stub_request(:post, "https://api.gotinder.com/profile")
        .with(
          body: {
            phone_number: phone_number,
            is_update:    false,
            otp_code:     confirmation_code
          })
        .to_return(body: { "meta": { "status": 200 }, "data": { "refresh_token": api_token, "validated": true } }.to_json)
    end

  end

end
