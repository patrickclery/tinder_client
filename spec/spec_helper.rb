require "bundler/setup"
require "tinder"
require "rspec"
require 'tinder/contexts/default'
require 'tinder/contexts/http_request_stubs'
require 'webmock/rspec'
require 'hashdiff' # Fix for webmock

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
