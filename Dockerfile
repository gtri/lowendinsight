ARG ALPINE_VERSION=3.10

FROM elixir:1.9.4-alpine AS builder

ARG MIX_ENV=dev

ENV MIX_ENV=dev
ENV LEI_BASE_TEMP_DIR=/tmp

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN MIX_ENV=${MIX_ENV} mix do deps.get, deps.compile, compile

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]