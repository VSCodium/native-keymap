#!/usr/bin/env bash
set -ex

EXPECTED_ARCH=${1:?"Expected arch (x64|arm64) is required"}
FILE=${2:?"Path to Mach-O binary is required"}

info=$(lipo -info "$FILE")
echo "$info"

case "$EXPECTED_ARCH" in
  x64)
    if ! echo "$info" | grep -qi 'x86_64'; then
      echo "Binary does not contain x86_64 slice" >&2
      exit 1
    fi
    ;;
  arm64)
    if ! echo "$info" | grep -qi 'arm64'; then
      echo "Binary does not contain arm64 slice" >&2
      exit 1
    fi
    ;;
  *)
    echo "Unsupported expected arch '$EXPECTED_ARCH'" >&2
    exit 1
    ;;
esac

echo "Mach-O architecture matches target '$EXPECTED_ARCH'"
