#!/usr/bin/env bash
set -ex

DEB_ARCH=${DEB_ARCH:-amd64}
TOOLCHAIN_PACKAGES=${TOOLCHAIN_PACKAGES:-}

SUDO=""
if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

if [ "$DEB_ARCH" != "amd64" ]; then
  $SUDO dpkg --add-architecture "$DEB_ARCH"
fi

$SUDO apt-get update -y
PKGS=(
  build-essential
  binutils
  python3
  pkg-config
  ninja-build
  "libx11-dev:${DEB_ARCH}"
  "libxkbfile-dev:${DEB_ARCH}"
  "libkrb5-dev:${DEB_ARCH}"
)

if [ -n "$TOOLCHAIN_PACKAGES" ]; then
  # shellcheck disable=SC2206
  EXTRA_PKGS=($TOOLCHAIN_PACKAGES)
  PKGS+=("${EXTRA_PKGS[@]}")
fi

DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y --no-install-recommends "${PKGS[@]}"
