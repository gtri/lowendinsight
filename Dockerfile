ARG ALPINE_VERSION=3.16

FROM elixir:1.14.1-alpine AS builder

ARG MIX_ENV=gha

ENV MIX_ENV=gha
ENV LEI_BASE_TEMP_DIR=/tmp

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY lib ./lib
COPY config ./config
COPY schema ./schema
COPY mix.exs ./mix.exs
COPY scripts ./scripts
COPY mix.lock ./mix.lock
COPY entrypoint.sh /entrypoint.sh

RUN MIX_ENV=${MIX_ENV} mix do deps.get, deps.compile, compile

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]