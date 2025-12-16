#!/usr/bin/env bash
set -ex

SOURCE_DIR=${1:-collected-artifacts}
DEST_DIR=${2:-release}

mkdir -p "$DEST_DIR"
find "$SOURCE_DIR" -type f -name '*.tar.gz*' -exec cp {} "$DEST_DIR"/ \;

find . -type f -name "*.tar.gz.sha256" | sort | xargs cat > checksum.txt
