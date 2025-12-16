#!/usr/bin/env bash
set -ex

EXPECTED_SLUG=${1:?"Expected architecture slug is required"}
FILE=${2:?"Path to ELF binary is required"}

header=$(readelf -h "$FILE")
machine=$(echo "$header" | awk -F: '/Machine:/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
if [ -z "$machine" ]; then
  echo "Unable to read ELF machine from header" >&2
  exit 1
fi

norm=$(echo "$machine" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9')
case "$norm" in
  advancedmicrodevicesx8664|x8664|amd64)
    actual="x64"
    ;;
  aarch64)
    actual="arm64"
    ;;
  arm|armlittleendian)
    actual="armhf"
    ;;
  riscv|riscv64)
    actual="riscv64"
    ;;
  loongarch|loongarch64)
    actual="loong64"
    ;;
  powerpc64|powerpc64littleendian)
    actual="ppc64le"
    ;;
  ibms390|s390)
    actual="s390x"
    ;;
  *)
    echo "Unrecognized machine '$machine'" >&2
    exit 1
    ;;
esac

if [ "$actual" != "$EXPECTED_SLUG" ]; then
  echo "Machine mismatch: expected $EXPECTED_SLUG but file reports $machine" >&2
  exit 1
fi

echo "Binary machine '$machine' matches target '$EXPECTED_SLUG'"
