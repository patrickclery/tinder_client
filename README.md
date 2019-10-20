RSpec Tests: [![CircleCI](https://circleci.com/gh/patrickclery/tinder_client.svg?style=svg)](https://circleci.com/gh/patrickclery/tinder_client)

Code Coverage: [![codecov](https://codecov.io/gh/patrickclery/tinder_client/branch/master/graph/badge.svg)](https://codecov.io/gh/patrickclery/tinder_client)

# TinderClient

A Ruby gem to interact with Tinder's REST API.

## Usage

### Rake Commands

```ruby
rake tinder:updates          # Fetch updates
rake tinder:profile          # Fetch my profile
rake tinder:recommendations  # Fetch recommendations
rake tinder:save_token       # Save an API token to $token_path ake tinder:get_updates      # Fetch updates
```

To grab a token, call a rake command & specify the `phone_number` or `api_token` in your environment variables.

### `rake tinder:save_token`

```
$ rake tinder:save_token \
phone_number=15556667777 \
tinder_token_path=/tmp
Enter the confirmation code sent to 15556667777> 
123456
Validating...
Done!
Your refresh token is eyJhbGciOiJIUzI1NiJ9.MTc3ODk5MDk4MDM.5q4R0H08rE0Dd9KgxMPp6jcTfIBLCXgEuVZfC9znJTE
Logging in...
Done!
Your tinder API token is 12a3bc45-a123-123a-1a23-1234abc4de5f
Saved to /tmp/tinder_access_token.txt
```


### Use Tinder Test-Helpers in your RSpec Tests 

`tinder_client` has _[webmock](https://github.com/bblimke/webmock) stubs_ you can include in your project to get fake responses back from Tinder:

```ruby
gem_dir = Gem::Specification.find_by_name("tinder_client").gem_dir
require "#{gem_dir}/spec/tinder/contexts/http_request_stubs"

RSpec.describe 'some test' do
  include_context 'http_request_stubs'

  # Your tests that use Tinder HTTP requests go here
end 
```
