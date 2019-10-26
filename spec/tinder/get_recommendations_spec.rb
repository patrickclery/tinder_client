RSpec.describe Tinder::Client do
  include_context 'default'
  include_context 'http request stubs'

  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }

  it { should respond_to(:get_recommendations).with(0).arguments }

  context 'Get a set of recommended users' do
    before do
      # Simulate when retrieving 3 packs of 4 recommended users, then running out of results
      stub_request(:get, "https://api.gotinder.com/v2/recs/core")
        .to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": recommendations_1 } }))
        .then.to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": recommendations_1 } }))
        .then.to_return(body: JSON.generate({ "meta": { "status": 200 }, "data": { "results": recommendations_1 } }))
        .then.to_return(body: JSON.generate({ "error": { "message": "There is no one around you" } }))

    end

    it 'can retrieve 3 collections of results' do
      # Returns sets of 4
      results = subject.get_recommendations
      expect(results.count).to be 4
      expect(results.all? { |obj| obj.kind_of?(Tinder::Recommendation) }).to be true

      # 2
      results = subject.get_recommendations
      expect(results.count).to be 4
      expect(results.all? { |obj| obj.kind_of?(Tinder::Recommendation) }).to be true

      # 3
      results = subject.get_recommendations
      expect(results.count).to be 4
      expect(results.all? { |obj| obj.kind_of?(Tinder::Recommendation) }).to be true

      # 4
      results = subject.get_recommendations
      expect(subject.get_recommendations).to be_empty
    end

    it 'can use a block to retrieve 3 collections of results' do

      expect do |block|
        subject.get_recommendations(&block)
      end.not_to yield_with_no_args

    end

  end

  context 'When rate limit is hit' do
    before do
      stub_request(:get, "https://api.gotinder.com/v2/recs/core")
        .to_return(body: JSON.generate({ "meta": { "status": 429 }, "error": { "message": "RATE_LIMITED", "code": 42901 } }))
    end

    it 'raises an exception' do
      expect { subject.get_recommendations }.to raise_error('Rate Limited')
    end

  end

  context 'When connection times out' do
    before do
      stub_request(:get, "https://api.gotinder.com/v2/recs/core")
        .to_return(body: JSON.generate({ "data": { "timeout": "Connection timeout." } }))
    end

    it 'raises an exception' do
      expect { subject.get_recommendations }.to raise_error('Connection Timeout')
    end

  end

  context 'When the max likes limit is reached' do
    before do
      json = JSON.generate({ "data": { "results": ['You are out of likes today. Come back later to continue swiping on more people.'] } })

      stub_request(:get, "https://api.gotinder.com/v2/recs/core")
        .to_return(body: json)
    end

    it 'fails silently when there are no likes left' do
      expect(subject.get_recommendations).to be_empty
    end

  end
end
