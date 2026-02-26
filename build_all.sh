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

# Inject version from git describe (e.g. 0.2.4 on tag, 0.2.4-3-gabc1234 after commits)
VERSION=$(git describe --tags --always 2>/dev/null | sed 's/^v//')
if [ -n "$VERSION" ]; then
  echo "▶ Injecting version: ${VERSION}"
  sed -i.bak "s/const VERSION = \".*\"/const VERSION = \"${VERSION}\"/" app.tsx
  rm -f app.tsx.bak
fi

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
