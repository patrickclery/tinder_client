require 'rspec'
require 'webmock'
require 'tinder'
require 'tinder/get_recommended_users'
require 'tinder/get_updates'

RSpec.describe Tinder::Client do
  include WebMock::API

  subject(:client) do
    described_class.tap { |client| client.api_token = api_token }
  end

  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let!(:results) { File.read("spec/fixtures/recommendations_1.json") }

  it { should respond_to(:get_recommended_users).with(0).arguments }

  context 'Successfully fetched results' do
    before do
      # Simulate when retrieving 3 results, then running out of results
      stub_request(:get, "https://api.gotinder.com/recs/core")
        .to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": results } }))
        .then.to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": results } }))
        .then.to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": results } }))
        .then.to_return(body: JSON.generate({ "error": { "message": "There is no one around you" } }))

    end

    it 'can retrieve 3 collections of results' do
      # Returns sets of 4
      results = subject.get_recommended_users
      expect(results.count).to be 4
      expect(results.all?{|obj| obj.kind_of?(Tinder::RecommendedUser)}).to be true

      # 2
      results = subject.get_recommended_users
      expect(results.count).to be 4
      expect(results.all?{|obj| obj.kind_of?(Tinder::RecommendedUser)}).to be true

      # 3
      results = subject.get_recommended_users
      expect(results.count).to be 4
      expect(results.all?{|obj| obj.kind_of?(Tinder::RecommendedUser)}).to be true

      # 4
      results = subject.get_recommended_users
      expect(subject.get_recommended_users).to be_empty
    end

    it 'can use a block to retrieve 3 collections of results' do
      expect { |block| subject.get_recommended_users(&block) }.to yield_with_no_args
    end

  end

  context 'When rate limit is hit' do
    before do
      stub_request(:get, "https://api.gotinder.com/recs/core")
        .to_return(body: JSON.generate({ "meta": { "status": 429 }, "error": { "message": "RATE_LIMITED", "code": 42901 } }))
    end

    it 'raises an exception' do
      expect { subject.get_recommended_users }.to raise_error('Rate Limited')
    end

  end

  context 'When connection times out' do
    before do
      stub_request(:get, "https://api.gotinder.com/recs/core")
        .to_return(body: JSON.generate({ "data": { "timeout": "Connection timeout." } }))
    end

    it 'raises an exception' do
      expect { subject.get_recommended_users }.to raise_error('Connection Timeout')
    end

  end

  context 'When the max likes limit is reached' do
    before do
      stub_request(:get, "https://api.gotinder.com/recs/core")
        .to_return(body: JSON.generate({ "data": { "results": ['You are out of likes today. Come back later to continue swiping on more people.'] } }))
    end

    it 'raises an exception' do
      expect { subject.get_recommended_users }.to raise_error('Out of likes')
    end

  end
end
