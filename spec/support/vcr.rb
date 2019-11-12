# NOTE: should be required after webmock
require "webmock/rspec"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__, "../cassettes/")
  config.hook_into :webmock
end
