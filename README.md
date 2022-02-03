# Forecasting app
## Description
[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Forecasting is a simple app made with `Rails 7.0.1` and `Ruby 2.7.3` that follows domain-driven design to structure the codebase. The domain, in this case, is `Forecasting`.

## Features

- Integration with Geocoding technologies like `Geocoding` and `Area`gems
- Integration with Third-party APIs like `OpenWeatherMap`
- Weather information is cached for 30 minutes since last request
- Good test coverage (around 80%)
- Frontend is decoupled and (almost) ready to be deployed as JAMstack 

## Tech

Forecasting uses the standard Ruby on rails modern stack:

- [Rails] - is a server-side web application framework written in Ruby
- [Stimulusjs] - A minimalist JavaScript framework built-in with Rails.
- [importmaps-rails] - lightweight solution for packaging js assets with Rails.
- [rspec] - Domain-specific language testing tool written in the programming language Ruby to test Ruby code.
- [redis] - an in-memory data structure store, used as a distributed, in-memory key–value database and cache solution.


## Design patterns and architectural decisions

Forecasting is a simple Rails app that follows, for the most part, Rails conventions. In order words, follows Model-View-Controller, Domain-driven design by leveraging [Rails namespaces conventions](https://blog.makandra.com/2014/12/organizing-large-rails-projects-with-namespaces/) and tries to be complain with [12-Factor App principles](https://12factor.net/)

### No Relation Database

Perhaps the only departure from the typical Rails app it is the fact, at least for the time being, Forecasting it is not making use of a relation database for storing information. This could be confusing since Rails requires kind of strictly to setup a DB before even lauching the server. The reasoning behind this is very simple, Forecasting, at least the this moment, doesn't require to count with a permanent persistance mechanism since there is no critical data needed for its operation. Other than cache data, that BTW it is stored with Redis, there is `Activerecord` model to found (or migration, etc). Having said that, it is very likely that a Relational db will be required for future features and that's why the dependency it is still listed in the `Gemfile` file.

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

Since the `master.key` file used for decrypting this `config/credentials.yml.enc` file shown above it is not included to the repo (not version controlled) you will need to regenerate it with the following command:

```sh
bundle exec rake secret
```

Then you can open it and edit it, in order to add you own `openweather_api_keys` for development and test enviroments (could be the same) with the following command.

```sh
EDITOR=vim rails credentials:edit
```

## Run on development

It is easy to be up and running with Forecasting, just open your favorite terminal and run this command:

```sh
rails s
```


#### Running tests

```sh
bundle exec rspec # unit tests
rails test:system # system tests
```

## License

MIT
