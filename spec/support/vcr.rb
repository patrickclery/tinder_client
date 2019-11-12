# NOTE: should be required after webmock
require "faraday"
require "vcr"
require "webmock/rspec"
require "multi_json"

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__, "../cassettes/")
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.default_cassette_options[:serialize_with] = :json
end

