#!/bin/bash

set -e # Fail the whole script on first error

# Fetch Ruby gem dependencies
bundle config path 'vendor/bundle'
bundle config with 'development test'
bundle install

echo "CHECKPOINT 1 OF 6"
# Make Gemfile.lock pristine again
git checkout -- Gemfile.lock

echo "CHECKPOINT 2 OF 6"
# Fetch Javascript dependencies
yarn --frozen-lockfile

echo "CHECKPOINT 3 OF 6"
# [re]create, migrate, and seed the test database
RAILS_ENV=test ./bin/rails db:setup

echo "CHECKPOINT 4 OF 6"
# [re]create, migrate, and seed the development database
RAILS_ENV=development ./bin/rails db:setup

echo "CHECKPOINT 5 OF 6"
# Precompile assets for development
RAILS_ENV=development ./bin/rails assets:precompile

echo "CHECKPOINT 6 OF 6"
# Precompile assets for test
RAILS_ENV=test NODE_ENV=tests ./bin/rails assets:precompile
