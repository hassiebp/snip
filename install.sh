#!/bin/bash

# Ensure the script is running on macOS.
if [ "$(uname)" != "Darwin" ]; then
  echo "Error: snip is only supported on macOS." >&2
  exit 1
fi

# Determine the installation directory.
TARGET_DIR="$HOME/.local/bin"
if [ ! -w "$TARGET_DIR" ]; then
  echo "No write permissions on $HOME directory"
  exit 1
fi

SNIP_URL="https://raw.githubusercontent.com/hassiebp/snip/master/bin/snip.sh"

echo "Downloading snip from $SNIP_URL..."

# Download the snip script to the target directory.
if ! curl -fsSL "$SNIP_URL" -o "$TARGET_DIR/snip"; then
  echo "Error: Failed to download snip." >&2
  exit 1
fi

# Make the script executable.
chmod +x "$TARGET_DIR/snip" || {
  echo "Error: Failed to set executable permissions." >&2
  exit 1
}

echo "snip has been installed to $TARGET_DIR/snip."
echo "Ensure that $TARGET_DIR is in your PATH."
