RSpec.describe Tinder::Client do
  include_context 'default'

  context 'User logged in' do
    # This will stub a request for updates with the dummy JSON response
    let!(:response) do
      File.read("spec/fixtures/updates.json")
    end

    before do
      stub_request(:get, "https://api.gotinder.com/updates")
        .to_return(body: response)
    end

    it 'can generate an Updates collection' do
      updates = subject.get_updates
      expect(updates).to be_a(Tinder::Updates)
    end
  end
end
