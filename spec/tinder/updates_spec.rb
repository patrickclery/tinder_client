RSpec.describe Tinder::Client do
  include_context 'default'
  include_context 'http request stubs'

  context 'User logged in' do
    it 'can generate an Updates collection' do
      updates = subject.get_updates
      expect(updates).to be_a(Tinder::Updates)
    end
  end
end
