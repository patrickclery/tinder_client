RSpec.describe Tinder::Client do
  include_context 'default'

  subject do
    described_class.tap { |client| client.api_token = api_token }
  end

  context 'User logged in' do

    let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
    let(:id) { "1a234a56123ab12345123456" }
    let(:phone_number) { "1234567890" }

    # Eager load this
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
