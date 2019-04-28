# README

## System dependencies

### Ruby version

At the time of writing, we're using `2.3.3`.
Please always check ruby version in `Gemfile`.

To manage different ruby versions you can use tools
like [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

### Gem

Please run `bundle` or `bundle install` to setup gem dependencies.

## Database creation and initialization

Make sure postgres is installed:

`brew install postgresql`

Make sure service is running:

`brew services start postgresql`

Create database and run existing migrations:

`bundle exec rails db:create`

`bundle exec rails db:migrate`

## Start server

`bundle exec rails s`

## How to run the test suite

We use `Rspec` for tests of this project. The command to run the tests of whole project:

`bundle exec rspec`

You could check more in:
https://github.com/rspec/rspec-rails

For spec structure we use `rspec-given`, to know more please go to:
https://github.com/jimweirich/rspec-given