RSpec.describe Tinder::Client do
  include WebMock::API

  subject { described_class.tap { |client| client.api_token = api_token } }
  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let!(:json) { File.read("spec/fixtures/profile.json") }

  it { should respond_to(:get_active_profile) }
  it { should respond_to(:get_active_profile).with(0).arguments }

  before do
    stub_request(:get, "https://api.gotinder.com/v2/profile?include=account,boost,email_settings,instagram,likes,notifications,plus_control,products,purchase,spotify,super_likes,tinder_u,travel,tutorials,user")
      .to_return(body: json)
  end

  it 'can fetch the active profile' do
    expect(subject.get_active_profile).to be_an(Tinder::ActiveProfile)
  end

end
