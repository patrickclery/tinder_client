require 'rspec'
require 'webmock'

RSpec.describe Tinder::Client do
  include WebMock::API

  subject { described_class }

  it { should respond_to(:get_active_profile) }
  it { should respond_to(:get_active_profile).with(0).arguments }

  let(:api_token) { "eyJhbGciOiJIUzI1NiJ9.MTc3ODk5MDk4MDM.5q4R0H08rE0Dd9KgxMPp6jcTfIBLCXgEuVZfC9znJTE" }
  let!(:json) do
    File.read("spec/fixtures/profile.json")
  end

  before do
    subject.api_token = api_token
    stub_request(:get, "http://api.gotinder.com/v2/profile?include=account,boost,email_settings,instagram,likes,notifications,plus_control,products,purchase,spotify,super_likes,tinder_u,travel,tutorials,user")
      .to_return(body: json)
  end

  it 'can fetch the active profile' do
    expect(subject.get_active_profile).to be_an(Tinder::ActiveProfile)
  end

end
