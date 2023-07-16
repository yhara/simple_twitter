# simple_twitter

Dead simple Twitter API client. Supports both v1 and v2

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/naclyhara/simple_twitter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
