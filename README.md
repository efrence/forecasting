[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Forecasting is a simple app made with `Rails 7.0.1` and `Ruby 2.7.3` that follows domain-driven design to structure the codebase. The domain, in this case, is `Forecasting`.

## Features

- Integration with Geocoding technologies like `Geocoding` and `Area`gems
- Integration with Third-party APIs like `OpenWeatherMap`
- Weather information is cached for 30 minutes since last request
- Good test coverage (around 80%)
- Frontend is decoupled and (almost) ready to be deployed as a [JAMStack](https://jamstack.org/)

## Tech

Forecasting uses the standard Ruby on rails modern stack:

- [`Rails`] - is a server-side web application framework written in Ruby
- [`Rspec`] - Domain-specific language testing tool written in the programming language Ruby to test Ruby code.
- [`Redis`] - an in-memory data structure store, used as a distributed, in-memory key–value database and cache solution.
- [`Stimulusjs`] - A minimalist JavaScript framework built-in with Rails.
- [`importmaps-rails`] - lightweight solution for packaging js assets with Rails.


## Design patterns and architectural decisions

Forecasting is a simple Rails app that follows, for the most part, Rails conventions. In order words, follows Model-View-Controller, Domain-driven design by leveraging [Rails namespaces conventions](https://blog.makandra.com/2014/12/organizing-large-rails-projects-with-namespaces/) and tries to be in complaince with the [12-Factor App principles](https://12factor.net/).

### File Structure

```

├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
│  ├── assets
│   │   ├── config
│   │   │   └── manifest.js
│   │   ├── images
│   │   └── stylesheets
│   │       └── application.css
│   ├── controllers
│   │   ├── application_controller.rb
│   │   ├── concerns
│   │   └── forecasting_controller.rb
│  ├── helpers
│   │   └── application_helper.rb
│  ├── javascript
│   │   ├── application.js
│   │   └── controllers
│   │       ├── application.js
│   │       ├── forecasting_controller.js
│   │       └── index.js
│  ├── models
│   │   ├── application_record.rb
│   │   ├── concerns
│   │   │   └── redis_persistable.rb
│   │   └── forecasting
│   │       ├── street_address.rb
│   │       ├── weather_with_coordinates.rb
│   │       ├── zipcode_with_coordinates.rb
│   │       └── zipcode_with_temperature.rb
│   ├── services
│   │   └── forecasting
│   │       ├── geocoding_service.rb
│   │       └── openweather_service.rb
│   └── views
│       ├── forecasting
│       │   └── new.html.erb
│       └── layouts
│           ├── application.html.erb
│           ├── mailer.html.erb
│           └── mailer.text.erb
| ── config
│   ├── application.rb
│   ├── boot.rb
│   ├── cable.yml
│   ├── credentials.yml.enc
│   ├── database.yml
│   ├── environment.rb
│   ├── environments
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── importmap.rb
│   ├── initializers
│   │   ├── assets.rb
│   │   ├── content_security_policy.rb
│   │   ├── filter_parameter_logging.rb
│   │   ├── inflections.rb
│   │   ├── permissions_policy.rb
│   │   └── redis.rb
│   ├── locales
│   │   └── en.yml
│   ├── master.key
│   ├── puma.rb
│   ├── redis.yml
│   ├── routes.rb
│   └── storage.yml
├── spec
│   ├── factories.rb
│   ├── helpers
│   ├── models
│   │   └── forecasting
│   │       ├── street_address_spec.rb
│   │       ├── weather_with_coordinates_spec.rb
│   │       ├── zipcode_with_coordinates_spec.rb
│   │       └── zipcode_with_temperature_spec.rb
│   ├── rails_helper.rb
│   ├── requests
│   │   └── forecasting_spec.rb
│   ├── services
│   │   └── forecasting
│   │       ├── geocoding_service_spec.rb
│   │       └── openweather_service_spec.rb
│   ├── shared_examples
│   │   └── redis_persistable.rb
│   ├── spec_helper.rb
│   └── support
│       ├── chrome.rb
│       └── factory_bot.rb
├── test
│   ├── application_system_test_case.rb
│   ├── channels
│   │   └── application_cable
│   │       └── connection_test.rb
│   ├── controllers
│   ├── fixtures
│   │   └── files
│   ├── helpers
│   ├── models
│   ├── system
│   │   └── forecasting_test.rb
│   └── test_helper.rb
```


### No Relational Database design

Perhaps the only departure from the typical Rails app it is the fact that, at least for the time being, Forecasting it is not making use of a relational database for storing information. This could be confusing since Rails requires kind of strictly to setup a DB before even lauching the server. The reasoning behind this is very simple, Forecasting, at least the this moment, doesn't require to count with a permanent persistance mechanism since there is no critical data needed for its operation. Other than cache data, that BTW it is stored with Redis, there is `Activerecord` model to found (or migration, etc). Having said that, it is very likely that a Relational db will be required for future features and that's why the dependency it is still listed in the `Gemfile` file.

## Installation and prerequirements

Forecasting requires [Ruby](https://www.ruby-lang.org/en/) 2.5+, [bundler](https://bundler.io/) 2.0+, redis and postgresql to run

Install the dependencies and devDependencies before starting the server by issuing the following commands:

```sh
brew install redis
brew install postgresql
gem install bundler
bundler install
rake db:create
./bin/importmap pin debounce axios
```

## Configuration

### Postgresql and Redis
It is using default database configuration so not need to change `config/database.yml` because it is using redis for all the data it needs. On another hand, if you need to change redis configuration, edit `config/redis.yml` file. For development purposes should work with default host `127.0.0.1` port `6379`. 

## Secrets
Forecasting uses rails secrets for storing sensitive information like the API key for Geocoding and Openweather services.
```.yml
secret_key_base: 08f43f89a7695886e43e3938df12b08b6ef8106752c3568bda9edefa4ef2991a968da0e40dbcfc149e9f0283f4f414dfaf4b96736a4857351eabf3b3a17a74da
test:
  openweather_api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
development:
  openweather_api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
production:
  openweather_api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

The file shown above can be found at `config/credentials.yml.enc` and it is included in repo thanks to the encryption provided by Rails secrets technology. However, the `master.key` file that it is need to decoded the credentials is not included to the repo, good news is that you can and will need to regenerate it in order to add your owns API keys. 

Generate a brand new credentials that can be modifiable with the following command:

```sh
bundle exec rake secret
```

Then you can open it and edit it, in order to add you own `openweather_api_keys` for development and test enviroments (could be the same) with the following command.

```sh
EDITOR=vim rails credentials:edit
```

## Run in development

It is easy to be up and running with Forecasting, just open your favorite terminal and run this command:

```sh
rails s
```

## Running tests

Forecasting was developed, to some extend,  using Test Driven Development so it includes a good coverage of tests using Rspec and built-in Rails system tests. In order to execute tests run the following commands:

```sh
bundle exec rspec # unit tests
rails test:system # system tests
```

## License

MIT
