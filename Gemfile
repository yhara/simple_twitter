# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in simple_twitter.gemspec
gemspec

gem "rake", "~> 13.0"

# FIXME: rbs bundled with ffi v1.17.0+ is broken
# c.f. https://github.com/ffi/ffi/issues/1107
gem "ffi", "< 1.17.0"

if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create("4.0.0")
  # cgi is bundled gem since ruby 4.0
  gem "cgi"
end
