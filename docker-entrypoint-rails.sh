#!/bin/bash
rm -f tmp/pids/server.pid && bundle exec rails server -b $HOST
