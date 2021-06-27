FROM node:14-alpine AS node

FROM elixir:1.12-alpine AS elixir

FROM alpine:3.14 AS app

ENV MIX_ENV=dev
ENV NODE_ENV=development

# install build dependencies
RUN apk add --update git vim bash inotify-tools libstdc++ libgcc openssl ncurses-libs
COPY --from=elixir /usr/local/lib/ /usr/local/lib/
COPY --from=elixir /usr/local/src/ /usr/local/src/
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules/

RUN ln -s /usr/local/lib/erlang/bin/erl /usr/local/bin/erl
RUN ln -s /usr/local/lib/elixir/bin/elixir /usr/local/bin/elixir
RUN ln -s /usr/local/lib/elixir/bin/mix /usr/local/bin/mix
RUN ln -s /usr/local/lib/elixir/bin/iex /usr/local/bin/iex
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix do local.hex --force, local.rebar --force

COPY . .
RUN mix phx.digest
ENTRYPOINT ["./docker/entrypoint.sh"]

