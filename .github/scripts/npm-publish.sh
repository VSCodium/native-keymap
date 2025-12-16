#!/usr/bin/env bash
set -ex

if [ -z "${NODE_AUTH_TOKEN:-}" ]; then
  echo "NPM token not present, skipping publish"
  exit 0
fi

npm publish --access public
