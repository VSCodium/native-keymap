#!/usr/bin/env bash
set -ex

usage() {
  cat <<'EOF'
Usage: verify-pe.sh <x64|arm64> <path-to-binary>
EOF
}

if [[ $# -ne 2 ]]; then
  usage >&2
  exit 1
fi

expected_arch=$1
file_path=$2

case "$expected_arch" in
  x64|arm64)
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

if [[ ! -f "$file_path" ]]; then
  printf "File '%s' not found\n" "$file_path" >&2
  exit 1
fi

read_le_value() {
  local bytes=$1
  local offset=$2
  od -An -t u$bytes -N$bytes -j "$offset" "$file_path" 2>/dev/null | tr -d '[:space:]'
}

pe_offset=$(read_le_value 4 60)
if [[ -z "$pe_offset" ]]; then
  echo "Failed to read PE header offset" >&2
  exit 1
fi

machine_offset=$((pe_offset + 4))
machine_value=$(read_le_value 2 "$machine_offset")
if [[ -z "$machine_value" ]]; then
  echo "Failed to read PE machine value" >&2
  exit 1
fi

case "$machine_value" in
  34404)
    actual="x64"
    ;;
  43620)
    actual="arm64"
    ;;
  *)
    printf 'Unknown PE machine 0x%04X\n' "$machine_value" >&2
    exit 1
    ;;
esac

if [[ "$actual" != "$expected_arch" ]]; then
  printf 'Machine mismatch: expected %s but file reports %s (0x%04X)\n' \
    "$expected_arch" "$actual" "$machine_value" >&2
  exit 1
fi

printf 'Binary machine 0x%04X matches target %s\n' "$machine_value" "$expected_arch"
