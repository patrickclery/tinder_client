require 'rspec'

RSpec.describe Tinder::Client do

  subject { described_class }

  it { should respond_to(:request) }
  it { should respond_to(:get) }
  it { should respond_to(:post) }

end
