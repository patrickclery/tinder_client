RSpec.describe Tinder do
  it { should be_a(Module) }
  it "has a version number" do
    expect(Tinder::VERSION).not_to be nil
  end

  # Verify that all the gems we need are being loaded
  describe 'Dependencies' do
    it { expect(Gem.loaded_specs.has_key? 'debase').to be true }
    it { expect(Gem.loaded_specs.has_key? 'dry-struct').to be true }
    it { expect(Gem.loaded_specs.has_key? 'dry-types').to be true }
    it { expect(Gem.loaded_specs.has_key? 'rspec').to be true }
    it { expect(Gem.loaded_specs.has_key? 'rspec-core').to be true }
    it { expect(Gem.loaded_specs.has_key? 'rubocop').to be true }
    it { expect(Gem.loaded_specs.has_key? 'rubocop-rspec').to be true }
    it { expect(Gem.loaded_specs.has_key? 'ruby-debug-ide').to be true }
    it { expect(Gem.loaded_specs.has_key? 'simplecov').to be true }
    it { expect(Gem.loaded_specs.has_key? 'vcr').to be true }
    it { expect(Gem.loaded_specs.has_key? 'webmock').to be true }
  end
end
