FROM emmajhyde/elixir-node-alpine

RUN mkdir /app

COPY mix.exs /app/mix.exs
COPY assets/package.json /app/assets/package.json
COPY entrypoint.sh /app/entrypoint.sh

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get
RUN npm install --prefix assets

CMD ["/app/entrypoint.sh"]
