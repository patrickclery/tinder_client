require 'rspec'

RSpec.describe Tinder::Client do

  subject { described_class }

  it { should respond_to(:send) }
  it { should respond_to(:get) }
  it { should respond_to(:post) }

end
