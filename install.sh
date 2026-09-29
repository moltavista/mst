#!/bin/sh
# Install the latest public mst CLI release after verifying its SHA-256 hash.
set -eu

base="https://github.com/moltavista/mst/releases/latest/download"
dir="${MST_INSTALL_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*" >&2; }
die() { say "mst install: $*"; exit 1; }

case "$(uname -s)" in
  Darwin) os=darwin ;;
  Linux) os=linux ;;
  *) die "unsupported operating system" ;;
esac
case "$(uname -m)" in
  x86_64 | amd64) arch=amd64 ;;
  arm64 | aarch64) arch=arm64 ;;
  *) die "unsupported architecture" ;;
esac

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL --retry 3 -o "$2" "$1"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -q -O "$2" "$1"; }
else
  die "curl or wget is required"
fi

if command -v sha256sum >/dev/null 2>&1; then
  sha256() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then
  sha256() { shasum -a 256 "$1" | cut -d' ' -f1; }
else
  die "sha256sum or shasum is required"
fi

tmp="$(mktemp -d 2>/dev/null || mktemp -d -t mst)"
trap 'rm -r "$tmp"' EXIT INT TERM
asset="mst-$os-$arch"
fetch "$base/$asset" "$tmp/$asset" || die "binary download failed"
fetch "$base/SHA256SUMS" "$tmp/SHA256SUMS" || die "checksum download failed"
fetch "$base/VERSION" "$tmp/VERSION" || die "version download failed"

want="$(awk -v f="$asset" '$2 == f || $2 == "*" f { print $1 }' "$tmp/SHA256SUMS" | head -n 1)"
[ -n "$want" ] || die "checksum for $asset is missing"
[ "$(sha256 "$tmp/$asset")" = "$want" ] || die "checksum mismatch for $asset; try again"

mkdir -p "$dir"
chmod 0755 "$tmp/$asset"
mv -f "$tmp/$asset" "$dir/mst"
say "Installed $dir/mst ($(cat "$tmp/VERSION"))."
say "Next: mst login"
