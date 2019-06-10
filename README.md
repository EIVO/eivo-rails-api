# EIVO Rails API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eivo-rails-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eivo-rails-api -N

## Usage

If you don't have a Ruby On Rails project:

	$ rails new ../example/ -d postgresql --skip-yarn --skip-active-storage --skip-action-cable --skip-sprockets --skip-spring --skip-coffee --skip-javascript --skip-turbolinks --skip-test --skip-system-test --skip-bootsnap --skip-action-mailer --api

Then:

	$ rails g eivo:install

Add missing credentials:

	$ rails credentials:edit

```
sentry:
  dsn: ""
```
