#!/usr/bin/env bash
set -ex

: "${GITHUB_OUTPUT:?GITHUB_OUTPUT environment variable is required}"

EVENT_NAME=${EVENT_NAME:-}
INPUT_VERSION=${INPUT_VERSION:-}
PUBLISH_INPUT=${PUBLISH_INPUT:-true}
RELEASE_TAG=${RELEASE_TAG:-}

VERSION="$INPUT_VERSION"
TAG=""

if [ -z "$VERSION" ]; then
  if [ "$EVENT_NAME" = "release" ]; then
    TAG="$RELEASE_TAG"
    if [ -z "$TAG" ]; then
      TAG="${GITHUB_REF_NAME:-}"
    fi
    TAG="${TAG#refs/tags/}"
    if [[ "$TAG" != v* ]]; then
      TAG="v${TAG}"
    fi
    VERSION="${TAG#v}"
  else
    VERSION=$(node -p "require('./package.json').version")
    TAG="v${VERSION}"
  fi
else
  if [[ "$VERSION" == v* ]]; then
    TAG="$VERSION"
    VERSION="${VERSION#v}"
  else
    TAG="v${VERSION}"
  fi
fi

if [ -z "$VERSION" ]; then
  echo "Unable to determine version" >&2
  exit 1
fi

SHOULD_PUBLISH="false"
if [ "$EVENT_NAME" = "release" ]; then
  SHOULD_PUBLISH="true"
else
  case "${PUBLISH_INPUT,,}" in
    true|1|yes)
      SHOULD_PUBLISH="true"
      ;;
  esac
fi

echo "version=${VERSION}" >> "$GITHUB_OUTPUT"
echo "tag=${TAG}" >> "$GITHUB_OUTPUT"
echo "should_publish=${SHOULD_PUBLISH}" >> "$GITHUB_OUTPUT"
