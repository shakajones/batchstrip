# Dockerfile
FROM elixir:1.12-alpine AS build

# install build dependencies
RUN apk add --update git vim bash inotify-tools
COPY --from=node:14-alpine /usr/local/bin/node /usr/local/bin/node
COPY --from=node:14-alpine /usr/local/lib/node_modules/ /usr/local/lib/node_modules
COPY --from=node:14-alpine /opt/yarn-*/ /opt/yarn/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn
RUN ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV NODE_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# build release
COPY . .
RUN mix test
RUN mix do compile, release

# prepare release image
FROM alpine:3.14 AS app
RUN apk update && apk add --no-cache bash libstdc++ libgcc openssl ncurses-libs

RUN mkdir /app && chown -R nobody:nobody /app
WORKDIR /app
USER nobody:nobody

ENV SECRET_KEY_BASE=wXCpLsHECKVHYhtz9/N4vYa0gIxL0Pq2IiEYayZSG3KCfYn6X1NuzAgsJf0PaNxh
COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/batchstrip ./

ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT
ENV HOME=/app

CMD ["bin/batchstrip", "start"]
