require 'rspec'
require 'webmock'
require 'tinder'
require 'tinder/feed'

RSpec.describe Tinder::Client do
  include WebMock::API

  subject do
    described_class.tap do |client|
      client.api_token = api_token
    end
  end

  context 'User logged in' do

    let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
    let(:confirmation_code) { "123456" }
    let(:id) { "1a234a56123ab12345123456" }
    let(:phone_number) { "1234567890" }
    let(:refresh_token) { "xxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }

    # Eager load this
    let!(:results) do
      JSON.parse(File.read("spec/fixtures/recommendations_1.json"))
    end

    context 'Successfully fetched results' do
      before do
        stub_request(:get, "https://api.gotinder.com/v2/recs/core")
          .to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": results } }))
      end

      it 'raises an exception' do
        feed = subject.feed(:recommendations)
        expect(feed).to be_a(Tinder::Feed)
        expect(feed.each).to eq results
      end

    end

    context 'When rate limit is hit' do
      before do
        stub_request(:get, "https://api.gotinder.com/v2/recs/core")
          .to_return(body: JSON.generate({ "meta": { "status": 429 }, "error": { "message": "RATE_LIMITED", "code": 42901 } }))
      end

      it 'raises an exception' do
        feed = subject.feed(:recommendations)
        expect(feed).to be_a(Tinder::Feed)
        expect { feed.each }.to raise_error('Rate Limited')
      end

    end

    context 'When connection times out' do
      before do
        stub_request(:get, "https://api.gotinder.com/v2/recs/core")
          .to_return(body: JSON.generate({ "data": { "timeout": "Connection timeout." } }))
      end

      it 'raises an exception' do
        feed = subject.feed(:recommendations)
        expect(feed).to be_a(Tinder::Feed)
        expect { feed.each }.to raise_error('Connection Timeout')
      end

    end

    context 'When the max likes limit is reached' do
      before do
        stub_request(:get, "https://api.gotinder.com/v2/recs/core")
          .to_return(body: JSON.generate({ "data": { "results": ['You are out of likes today. Come back later to continue swiping on more people.'] } }))
      end

      it 'raises an exception' do
        feed = subject.feed(:recommendations)
        expect(feed).to be_a(Tinder::Feed)
        expect { feed.each }.to raise_error('Out of likes')
      end

    end
  end
end
