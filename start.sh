#!/bin/sh

if [ "${RAILS_ENV}" = "production" ]
then
    echo "Running assets precompile for production..."
    bundle exec rails assets:precompile
fi

# Railsサーバーを起動
bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0