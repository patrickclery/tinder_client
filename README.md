RSpec Tests: [![CircleCI](https://circleci.com/gh/patrickclery/tinder_client.svg?style=svg)](https://circleci.com/gh/patrickclery/tinder_client)

# TinderClient

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/tinder_client`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinder_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinder_client

## Usage

```ruby
rake tinder:get_updates      # Fetch updates
rake tinder:profile          # Fetch my profile
rake tinder:recommendations  # Fetch recommendations
rake tinder:save_token       # Save an API token to $token_path ake tinder:get_updates      # Fetch updates
```

## Development

`tinder_client` has a test suite that stubs out real HTTP connections with dummy responses. If you're making an app that uses `tinder_client`, you can include the file `spec/tinder/contexts/http_request_stubs` in your spec helper and include it in your tests:

**in your spec_helper.rb:**
```ruby
gem_dir = Gem::Specification.find_by_name("tinder_client").gem_dir
require "#{gem_dir}/spec/tinder/contexts/http_request_stubs"
```

**in your spec test:**
```ruby
RSpec.describe 'some test' do
  include_context 'http_request_stubs'

  # Your tests that use Tinder HTTP requests go here
end 
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tinder_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TinderClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tinder_client/blob/master/CODE_OF_CONDUCT.md).
