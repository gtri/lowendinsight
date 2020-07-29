#!/bin/sh -l

cd /opt/app
mix local.hex --force
mix lei.scan ${GITHUB_WORKSPACE}