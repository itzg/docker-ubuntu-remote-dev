#!/usr/bin/env sh

useradd \
  --home-dir="${DEV_USER_HOME}" \
  --no-create-home \
  --uid 1000 \
  --shell /bin/bash \
  "${DEV_USER_NAME}"

