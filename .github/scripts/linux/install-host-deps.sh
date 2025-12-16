#!/usr/bin/env bash
set -ex

SUDO=""
if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

packages=(
  build-essential
  binutils
  python3
  libx11-dev
  libxkbfile-dev
)

$SUDO apt-get update -y
DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y --no-install-recommends "${packages[@]}"
