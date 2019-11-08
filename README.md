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

## Accessing your saved data

`better_tinder` converts responses from Tinder from raw JSON data to `Dry::Struct`, for your convenience.

That means, call the services with your API token to return a struct:  

### `SaveRecommendations.call(api_token:)`

  ```ruby
  class Photo < Dry::Struct
    attribute :id, Types.string
    attribute? :crop_info do
      attribute? :user do
        attribute :width_pct, Dry::Types['coercible.float']
        attribute :x_offset_pct, Types.float
        attribute :height_pct, Types.float
        attribute :y_offset_pct, Types.float
      end
      attribute? :algo do
        attribute :width_pct, Types.float
        attribute :x_offset_pct, Types.float
        attribute :height_pct, Types.float
        attribute :y_offset_pct, Types.float
      end
      attribute :processed_by_bullseye, Types.bool
      attribute :user_customized, Types.bool
      attribute? :url, Types.string
      attribute? :processedFiles, Types.array
      attribute? :fileName, Types.string
      attribute? :extension, Types.string
    end
  end

  class User < Dry::Struct
    attribute :_id, Types.string
    attribute :bio, Types.string
    attribute :birth_date, Types.string
    attribute :name, Types.string
    attribute :photos, Types.array.of(Photo)
    attribute :gender, Types.integer
    attribute :jobs, Types.array
    attribute :schools, Types.array do
      attribute :name, Types.string
    end
    attribute? :city do
      attribute :name, Types.string
    end
    attribute? :is_traveling, Types.bool
    attribute? :hide_age, Types.bool
    attribute? :hide_distance, Types.bool
  end

  # Return this object
  class Recommendation < Dry::Struct
    attribute :type, Types.string
    attribute :user, User
    attribute :facebook do
      attribute :common_connections, Types.array
      attribute :connection_count, Types.integer
      attribute :common_interests, Types.array
    end
    attribute :spotify, Types.hash
    attribute :distance_mi, Types.integer
    attribute :content_hash, Types.string
    attribute :s_number, Types.integer
    attribute :teasers, Types.array do
      attribute :type, Types.string
      attribute :string, Types.string
    end
  end
  ```


### `SaveUpdates.call(api_token:)`

  ```ruby
  class Message < Dry::Struct
    attribute :_id, Types.string
    attribute :match_id, Types.string
    attribute :sent_date, Types.string
    attribute :message, Types.string
    attribute :to, Types.string
    attribute :from, Types.string
    attribute :created_date, Types.string
    attribute :timestamp, Types.send('coercible.string')
  end

  class LikedMessage < Dry::Struct
    attribute :message_id, Types.string
    attribute :updated_at, Types.string
    attribute :liker_id, Types.string
    attribute :match_id, Types.string
    attribute :is_liked, Types.bool
  end

  class Person < Dry::Struct
    attribute? :bio, Types.string
    attribute :birth_date, Types.string
    attribute :gender, Types.integer
    attribute :name, Types.string
    attribute :ping_time, Types.string
    attribute :photos, Types.array
  end

  class Match < Dry::Struct
    attribute :_id, Types.string
    attribute :closed, Types.bool
    attribute :common_friend_count, Types.integer
    attribute :common_like_count, Types.integer
    attribute :created_date, Types.string
    attribute :dead, Types.bool
    attribute :following, Types.bool
    attribute :following_moments, Types.bool
    attribute :id, Types.string
    attribute :is_boost_match, Types.bool
    attribute :is_fast_match, Types.bool
    attribute :is_super_like, Types.bool
    attribute :last_activity_date, Types.string
    attribute :message_count, Types.integer
    attribute :messages, Types.array.of(Message)
    attribute :muted, Types.bool
    attribute :participants, Types.array
    attribute :pending, Types.bool
    attribute :person, Person
    attribute :readreceipt, Types.hash
    attribute :seen, Types.hash
  end

  class Updates < Dry::Struct
    attribute :blocks, Types.array.of(Types.string)
    attribute :deleted_lists, Types.array
    attribute :goingout, Types.array
    attribute :harassing_messages, Types.array
    attribute :inbox, Types.array.of(Message)
    attribute :poll_interval, Types.hash
    attribute :liked_messages, Types.array.of(LikedMessage)
    attribute :lists, Types.array
    attribute :matches, Types.array.of(Match)
    attribute :squads, Types.array
  end
  ```

