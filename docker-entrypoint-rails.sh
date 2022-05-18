#!/bin/bash
bundle exec rake db:migrate db:seed 2>/dev/null || bundle exec rake db:setup

rm -f tmp/pids/server.pid && bundle exec rails server -b $HOST
