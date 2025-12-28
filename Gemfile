# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in simple_twitter.gemspec
gemspec

gem "rake", "~> 13.0"

# FIXME: Remove following after https://github.com/laserlemon/simple_oauth/pull/30 is merged and released
if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create("4.0.0")
  # cgi is bundled gem since ruby 4.0
  gem "cgi"
end
