#!/usr/bin/env bash
set -ex

: "${GNU_TRIPLET:?GNU_TRIPLET is required}"
: "${NPM_ARCH:?NPM_ARCH is required}"

# Respect optional compiler overrides exported from the workflow step (CC, CXX, AR, RANLIB).
export PKG_CONFIG_PATH="/usr/lib/${GNU_TRIPLET}/pkgconfig:/usr/lib/${GNU_TRIPLET}/lib/pkgconfig:/usr/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export PKG_CONFIG_LIBDIR="/usr/lib/${GNU_TRIPLET}/pkgconfig:/usr/lib/${GNU_TRIPLET}/lib/pkgconfig:/usr/share/pkgconfig"

npx node-gyp rebuild --arch="${NPM_ARCH}"
