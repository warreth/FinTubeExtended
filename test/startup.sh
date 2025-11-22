#!/bin/bash
PLUGIN_DIR="/config/plugins/FinTube"

# Clean up old plugin versions
rm -rf "$PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR"

# Copy new plugin files
echo "Installing plugin to $PLUGIN_DIR..."
cp -a /temp-plugin/* "$PLUGIN_DIR/"

echo "Installed FinTube plugin to $PLUGIN_DIR"

exec /jellyfin/jellyfin
