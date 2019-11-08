RSpec.describe Tinder::Client do
  include_context 'default'
  include_context 'http request stubs'

  describe '#updates', type: :method do
    it { expect(subject).to respond_to(:updates) }
    it { expect(subject.updates).to be_a(Tinder::Updates) }
  end
end
