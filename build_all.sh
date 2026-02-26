#!/usr/bin/env bash
# Build ansible-tui for all supported platforms using Deno
# Output goes to dist/
set -euo pipefail

TARGETS=(
  "x86_64-unknown-linux-gnu:linux-amd64"
  "aarch64-unknown-linux-gnu:linux-arm64"
  "x86_64-apple-darwin:macos-amd64"
  "aarch64-apple-darwin:macos-arm64"
)

mkdir -p dist

for entry in "${TARGETS[@]}"; do
  target="${entry%%:*}"
  name="${entry##*:}"
  out="dist/ansible-tui-${name}"
  echo "▶ Compiling ${name} (${target})..."
  deno compile \
    --allow-read --allow-run --allow-write --allow-env \
    --target "${target}" \
    -o "${out}" \
    app.tsx
  echo "  ✓ ${out}"
done

# Also build native (current platform) as dist/ansible-tui for quick local use
echo "▶ Compiling native (current platform)..."
deno compile \
  --allow-read --allow-run --allow-write --allow-env \
  -o dist/ansible-tui \
  app.tsx
echo "  ✓ dist/ansible-tui"

echo
echo "Done! Artifacts in dist/:"
ls -lh dist/
