RSpec.describe Tinder::Client do

  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let!(:json) { File.read(File.join(__dir__, "./fixtures/settings.json")) }

  it { should respond_to(:account_settings) }
  it { should respond_to(:account_settings).with(0).arguments }

  before do
    stub_request(:get, "https://api.gotinder.com/v2/meta")
      .to_return(body: json)
  end

  context 'logged in' do
    before { subject.api_token = api_token }
    it 'can retrieve active user account settings' do
      expect(subject.account_settings).to be_an(Tinder::AccountSettings)
    end
  end

end
