FROM node:14-alpine AS node

FROM elixir:1.12-alpine AS build

# set build ENV
ENV MIX_ENV=prod
ENV NODE_ENV=prod

# install build dependencies
RUN apk add --update git vim bash
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix do local.hex --force, local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, compile

# install node depedencies & perform webpack deploy for production
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# test, and build release w/ static assets
COPY . .
RUN mix test
RUN mix do phx.digest, release

# prepare release image
FROM alpine:3.14 AS app
RUN apk add --update --no-cache libstdc++ libgcc openssl

RUN mkdir /app && chown -R nobody:nobody /app
WORKDIR /app
USER nobody:nobody

# copy only the release build from the other image
COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/batchstrip ./

ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT
ENV HOME=/app

CMD ["bin/batchstrip", "start"]
