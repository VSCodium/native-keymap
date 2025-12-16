#!/usr/bin/env bash
set -ex

: "${NPM_ARCH:?NPM_ARCH is required}"
: "${CLANG_ARCH:?CLANG_ARCH is required}"
: "${DEPLOYMENT_TARGET:?DEPLOYMENT_TARGET is required}"

SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
export SDKROOT

CFLAGS="-arch ${CLANG_ARCH} -mmacosx-version-min=${DEPLOYMENT_TARGET} ${CFLAGS:-}"
CXXFLAGS="-arch ${CLANG_ARCH} -mmacosx-version-min=${DEPLOYMENT_TARGET} ${CXXFLAGS:-}"
LDFLAGS="-arch ${CLANG_ARCH} -mmacosx-version-min=${DEPLOYMENT_TARGET} ${LDFLAGS:-}"

export CFLAGS CXXFLAGS LDFLAGS

npx node-gyp rebuild --arch="${NPM_ARCH}"
