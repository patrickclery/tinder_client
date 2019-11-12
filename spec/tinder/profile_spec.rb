RSpec.describe Tinder::Client, vcr: true do
  include_context 'default'
  include_context 'http request stubs'

  it { should respond_to(:profile) }
  it { should respond_to(:profile).with(0).arguments }

  before { subject.api_token = api_token }
  it 'can fetch the active profile' do
    expect(subject.profile).to be_a(Tinder::ActiveProfile)
  end

end
