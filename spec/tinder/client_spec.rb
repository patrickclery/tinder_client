RSpec.describe Tinder::Client, vcr: true do
  include_context 'default'
  include_context 'http request stubs'

  it { should respond_to(:endpoint).with(1).argument }
  it { should respond_to(:get).with(1).arguments }
  it { should respond_to(:post).with(1).arguments }
  it { should respond_to(:request_code).with(1).argument }
  it { should respond_to(:validate).with(2).arguments }

  it { should respond_to(:api_token) }
  it { should respond_to(:refresh_token) }

  it 'can login via phone number and confirmation code' do
    expect(subject.request_code(phone_number)).to be true
    expect(subject.validate(phone_number, confirmation_code)).to eq refresh_token
    expect(subject.refresh_token).to eq(refresh_token)
    expect(subject.login(phone_number, refresh_token)).to eq api_token
    expect(subject.api_token).to eq(api_token)
  end

end
