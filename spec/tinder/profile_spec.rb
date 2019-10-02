RSpec.describe Tinder::Client do
  include_context 'default'

  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let!(:json) { File.read("#{File.dirname(__FILE__)}/../fixtures/profile.json") }

  it { should respond_to(:profile) }
  it { should respond_to(:profile).with(0).arguments }

  before do
    stub_request(:get, "https://api.gotinder.com/v2/profile?include=account,boost,email_settings,instagram,likes,notifications,plus_control,products,purchase,spotify,super_likes,tinder_u,travel,tutorials,user")
      .to_return(body: json)
  end

  context 'logged in' do
    before { subject.api_token = api_token }
    it 'can fetch the active profile' do
      expect(subject.profile).to be_an(Tinder::ActiveProfile)
    end
  end

end
