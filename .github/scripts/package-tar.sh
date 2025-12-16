#!/usr/bin/env bash
set -ex

: "${PREBUILT_DIR:?PREBUILT_DIR environment variable is required}"

TARGET_PLATFORM=${1:?'Target platform is required'}
TARGET_ARCH=${2:?'Target architecture is required'}
PACKAGE_VERSION=${3:?'Package version is required'}
BINARY_PATH=${4:-build/Release/keymapping.node}

RUNTIME=${PREBUILT_RUNTIME:-node}
NODE_ABI=${PREBUILT_NODE_ABI:-$(node -p "process.versions.modules" 2>/dev/null)}

if [[ -z "$NODE_ABI" ]]; then
  echo "Unable to determine Node ABI" >&2
  exit 1
fi

DEST_DIR="${PREBUILT_DIR}/${TARGET_PLATFORM}-${TARGET_ARCH}"
ARCHIVE_BASENAME="native-keymap-v${PACKAGE_VERSION}-${RUNTIME}-v${NODE_ABI}-${TARGET_PLATFORM}-${TARGET_ARCH}"
ARCHIVE_NAME="${ARCHIVE_BASENAME}.tar.gz"
ARCHIVE_PATH="${PREBUILT_DIR}/${ARCHIVE_NAME}"
HASH_PATH="${ARCHIVE_PATH}.sha256"

mkdir -p "$DEST_DIR"
cp "$BINARY_PATH" "${DEST_DIR}/keymapping.node"

tar -czf "$ARCHIVE_PATH" -C "$DEST_DIR" keymapping.node

if command -v sha256sum >/dev/null 2>&1; then
  (cd "$PREBUILT_DIR" && sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256")
elif command -v shasum >/dev/null 2>&1; then
  (cd "$PREBUILT_DIR" && shasum -a 256 "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256")
else
  echo "No SHA256 tool available" >&2
  exit 1
fi

echo "Packaged $ARCHIVE_NAME and checksum"
