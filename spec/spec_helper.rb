### Support for CodeCov
require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require "bundler/setup"
require "tinder"
require "rspec"
require 'webmock/rspec'
require 'hashdiff' # Fix for webmock

Dir['./spec/tinder/contexts/**.rb'].each do |f|
  require f.sub(%r|\./spec/|, '')
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

WebMock.enable!
