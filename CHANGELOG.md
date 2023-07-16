## Unreleased
https://github.com/yhara/simple_twitter/compare/v1.0.0...main

### :bomb: [BREAKING CHANGE] positional args to keywords args
Since v2.0, the positional arguments of the following methods are now keyword arguments.

| v1.0                                                 | v2.0+                                                         |
| ---------------------------------------------------- | ------------------------------------------------------------- |
| `SimpleTwitter::Client#get(url, params = {})`        | `SimpleTwitter::Client#get(url, params: {}, json: {})`        |
| `SimpleTwitter::Client#get_raw(url, params = {})`    | `SimpleTwitter::Client#get_raw(url, params: {}, json: {})`    |
| `SimpleTwitter::Client#post(url, params = {})`       | `SimpleTwitter::Client#post(url, params: {}, json: {})`       |
| `SimpleTwitter::Client#post_raw(url, params = {})`   | `SimpleTwitter::Client#post_raw(url, params: {}, json: {})`   |
| `SimpleTwitter::Client#put(url, params = {})`        | `SimpleTwitter::Client#put(url, params: {}, json: {})`        |
| `SimpleTwitter::Client#put_raw(url, params = {})`    | `SimpleTwitter::Client#put_raw(url, params: {}, json: {})`    |
| `SimpleTwitter::Client#delete(url, params = {})`     | `SimpleTwitter::Client#delete(url, params: {}, json: {})`     |
| `SimpleTwitter::Client#delete_raw(url, params = {})` | `SimpleTwitter::Client#delete_raw(url, params: {}, json: {})` |

Please modify as follows when you upgrade from v1.0 :pray:

Before (v1.0)

```ruby
client.get("https://api.twitter.com/2/tweets", ids: "1302127884039909376,1369885448319889409")
```

After (v2.0+)

```ruby
client.get("https://api.twitter.com/2/tweets", params: { ids: "1302127884039909376,1369885448319889409" })
```

If only 1 argument was used (e.g. `client.get("https://api.twitter.com/2/users/me")`), no modification is required.

See more. https://github.com/yhara/simple_twitter/pull/3

### :bomb: [BREAKING CHANGE] raise Error when Twitter API returned error
Until v1.0, even if the Twitter API returns an error, Ruby does not throw an error, so it is considered a normal exit.

This is confusing, so when the API returns an error, Ruby also raises an error.

Before (v1.0)

```ruby
client = SimpleTwitter::Client.new(bearer_token: "dummy")
client.get("https://api.twitter.com/2/users/me")
#=> 
{:title=>"Unsupported Authentication",
 :detail=>
  "Authenticating with OAuth 2.0 Application-Only is forbidden for this endpoint.  Supported authentication types are [OAuth 1.0a User Context, OAuth 2.0 User Context].",
 :type=>"https://api.twitter.com/2/problems/unsupported-authentication",
 :status=>403}
```

After (v2.0+)

```ruby
client = SimpleTwitter::Client.new(bearer_token: "dummy")
client.get("https://api.twitter.com/2/users/me")
/path/to/simple_twitter/lib/simple_twitter.rb:96:in `parse_response': Unsupported Authentication (status 403) (SimpleTwitter::ClientError)
        from (eval):6:in `get'
        from (irb):2:in `<main>'
        from ./bin/console:15:in `<main>'
```

Detailed error details can be obtained as follows

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

See more. 

* https://github.com/yhara/simple_twitter/pull/2
* https://github.com/yhara/simple_twitter/pull/15

### Features
- Enabled rubygems_mfa_required
  - https://github.com/yhara/simple_twitter/pull/9
- Add changelog_uri to gemspec
  - https://github.com/yhara/simple_twitter/pull/10
- Write YARD comment and publish to Pages
  - https://github.com/yhara/simple_twitter/pull/13
- Add documentation_uri to gemspec metadata
  - https://github.com/yhara/simple_twitter/pull/16

### Others
- Add @sue445 as an author
  - https://github.com/yhara/simple_twitter/pull/6
- Add tests and CI
  - https://github.com/yhara/simple_twitter/pull/7
  - https://github.com/yhara/simple_twitter/pull/12

## v1.0.0 (2021-03-28)

- initial release
