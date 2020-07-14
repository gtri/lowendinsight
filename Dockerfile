ARG ALPINE_VERSION=3.10

FROM elixir:1.9.4-alpine AS builder

ARG MIX_ENV=dev

ENV MIX_ENV=dev
ENV LEI_BASE_TEMP_DIR=/tmp
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN MIX_ENV=${MIX_ENV} mix do deps.get, deps.compile, compile

ENTRYPOINT ["sh", "/entrypoint.sh"]