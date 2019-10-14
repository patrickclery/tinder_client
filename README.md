RSpec Tests: [![CircleCI](https://circleci.com/gh/patrickclery/tinder_client.svg?style=svg)](https://circleci.com/gh/patrickclery/tinder_client)

Code Coverage: [![codecov](https://codecov.io/gh/patrickclery/tinder_client/branch/master/graph/badge.svg)](https://codecov.io/gh/patrickclery/tinder_client)

# TinderClient

A Ruby gem to interact with Tinder's REST API.

## Usage

```ruby
rake tinder:get_updates      # Fetch updates
rake tinder:profile          # Fetch my profile
rake tinder:recommendations  # Fetch recommendations
rake tinder:save_token       # Save an API token to $token_path ake tinder:get_updates      # Fetch updates
```

### Use Tinder Test-Helpers in your Project 

`tinder_client` has _[webmock](https://github.com/bblimke/webmock) stubs_ you can include in your project to get fake responses back from Tinder:

```ruby
gem_dir = Gem::Specification.find_by_name("tinder_client").gem_dir
require "#{gem_dir}/spec/tinder/contexts/http_request_stubs"

RSpec.describe 'some test' do
  include_context 'http_request_stubs'

  # Your tests that use Tinder HTTP requests go here
end 
```
