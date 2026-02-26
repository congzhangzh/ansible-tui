#!/bin/sh
set -e

# Ansible TUI simple installer

REPO="<user>/<repo>" # To be replaced with actual repo
BINARY_NAME="ansible-tui"

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux)
    if [ "$ARCH" = "x86_64" ]; then
      TARGET="linux-amd64"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
      TARGET="linux-arm64"
    else
      echo "Unsupported architecture: $ARCH"
      exit 1
    fi
    ;;
  darwin)
    if [ "$ARCH" = "x86_64" ]; then
      TARGET="macos-amd64"
    elif [ "$ARCH" = "arm64" ]; then
      TARGET="macos-arm64"
    else
      echo "Unsupported architecture: $ARCH"
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

RELEASE_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}-${TARGET}"

echo "Downloading ${BINARY_NAME} for ${OS}-${TARGET}..."
curl -sL "$RELEASE_URL" -o "$BINARY_NAME"
chmod +x "$BINARY_NAME"

echo
echo "Successfully installed ${BINARY_NAME}!"
echo "You can move it to your path with:"
echo "  sudo mv ${BINARY_NAME} /usr/local/bin/"
