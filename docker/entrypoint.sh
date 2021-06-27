#!/bin/bash
# install mix dependencies
mix do deps.get, deps.compile, compile
# install node dependencies & perform webpack deploy for production
npm install --prefix assets
mix phx.server
