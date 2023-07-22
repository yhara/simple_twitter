# simple_twitter

Dead simple Twitter API client. Supports both v1 and v2

[![Gem Version](https://badge.fury.io/rb/simple_twitter.svg)](https://badge.fury.io/rb/simple_twitter)
[![test](https://github.com/yhara/simple_twitter/actions/workflows/test.yml/badge.svg)](https://github.com/yhara/simple_twitter/actions/workflows/test.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_twitter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simple_twitter

## Example

```rb
require 'simple_twitter'

client = SimpleTwitter::Client.new(bearer_token: "...")
pp client.get("https://api.twitter.com/2/tweets",
              params: { ids: "1302127884039909376,1369885448319889409" })
```

Result:

```
{:data=>
  [{:id=>"1302127884039909376",
    :text=>
     "We conclude RubyKaigi Takeout 2020. We hope we can meet in-person, safely at RubyKaigi 2021 in Mie! Thank you all for tuning in. #rubykaigi"},
   {:id=>"1369885448319889409",
    :text=>
     "RubyKaigi 2021 is going online again: RubyKaigi Takeout 2021 will happen this fall. https://t.co/Fv1PlvmUHh"}]}
```

As you see hash keys are converted into symbols (Note that strings as values are not converted.)

### Call API on user context 

Some operations (eg. posting a tweet) needs OAuth instead of `bearer_token`.

```rb
config = (load from yaml or something)
client = SimpleTwitter::Client.new(
  api_key: config[:api_key],
  api_secret_key: config[:api_secret_key],
  access_token: config[:access_token],
  access_token_secret: config[:access_token_secret],
)
pp client.post("https://api.twitter.com/1.1/statuses/update.json",
               params: { status: "Test." })
```

You can get the access_token and access_token_secret for your own at the Twitter Developer Portal. For other users, you need to get them via OAuth (out of scope of this gem.)

### Post with JSON body
Since Twitter API v2, POST must be sent as JSON body

e.g.https://developer.twitter.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets

Send using the `json` argument.

e.g.

```ruby
client = SimpleTwitter::Client.new(bearer_token: ENV["ACCESS_TOKEN"])
client.post("https://api.twitter.com/2/tweets", json: { text: "Hello twitter!" })
```

### Upload media
If you want to tweet with an image, you need to do the following steps

1. Upload image as media
    * c.f. https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload
2. Tweet with media
    * c.f. https://developer.twitter.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets

e.g.

```ruby
config = (load from yaml or something)
client = SimpleTwitter::Client.new(
  api_key: config[:api_key],
  api_secret_key: config[:api_secret_key],
  access_token: config[:access_token],
  access_token_secret: config[:access_token_secret],
)

# Upload image as media
media = client.post(
          "https://upload.twitter.com/1.1/media/upload.json",
          form: {
            media: HTTP::FormData::File.new("/path/to/image.png")
          }
        )
# =>
# {:media_id=>12345678901234567890,
#  :media_id_string=>"12345678901234567890",
#  :size=>60628,
#  :expires_after_secs=>86400,
#  :image=>{:image_type=>"image/png", :w=>400, :h=>400}}

# Tweet with media
client.post(
  "https://api.twitter.com/2/tweets",
  json: { 
    text: "Test tweet with image", 
    media: { media_ids: [media[:media_id_string]] },
  }
)
```

### Advanced

If you want the raw json string or use streaming API, use `get_raw`, `post_raw`, etc. which returns `HTTP::Response` of the [http gem](https://github.com/httprb/http).

```rb
res = client.get_raw("https://api.twitter.com/2/tweets/sample/stream")
p res #=> #<HTTP::Response ...>
loop do
  puts res.body.readpartial
end
```

### Hint

Some API parameters has `.` in its name (eg. `tweet.fields`.) Did you know that in Ruby you can include `.` in a hash key if quoted? :-)

```rb
tweets = @client.get("https://api.twitter.com/2/users/#{id}/tweets", params: {
  expansions: "author_id",
  max_results: 100,
  "tweet.fields": "author_id,created_at,referenced_tweets,text",
})
```

### Detailed error details
If an error is returned from the API, you may need more information.

In such cases, you can retrieve it as follows.

```ruby
begin
  client = SimpleTwitter::Client.new(bearer_token: "invalid_bearer_token")
  client.get("https://api.twitter.com/2/users/me")
rescue SimpleTwitter::Error => error
  error.raw_response.class
  #=> HTTP::Response

  error.raw_response.code
  #=> 403

  error.body[:title]
  # => "Unsupported Authentication"
end
```

See more. [SimpleTwitter::Error](https://yhara.github.io/simple_twitter/SimpleTwitter/Error.html)

## API Reference
See https://yhara.github.io/simple_twitter/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yhara/simple_twitter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
