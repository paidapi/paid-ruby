# Paid Ruby bindings ![Travis CI Status](https://travis-ci.org/paidapi/paid-ruby.svg?branch=master)


## Installation

You don't need this source code unless you want to modify the gem. If
you just want to use the Paid Ruby bindings, you should run:

```bash
gem install paid
```

If you want to build the gem from source:

```bash
gem build paid.gemspec
```


## Requirements

* Ruby 1.8.7 or above. (Ruby 1.8.6 may work if you load
  ActiveSupport.) For Ruby versions before 1.9.2, you'll need to add this to your Gemfile:

```ruby
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.9.2')
  gem 'rest-client', '~> 1.6.8'
end
```

* rest-client, json


## Bundler

If you are installing via bundler, you should be sure to use the https
rubygems source in your Gemfile, as any gems fetched over http could potentially be compromised.

```ruby
source 'https://rubygems.org'

gem 'rails'
gem 'paid'
```


## Development

Test cases can be run with: `bundle exec rake test`
