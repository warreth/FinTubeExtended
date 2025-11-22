#!/bin/bash

# Simplified build script for FinTube
set -e

# --- Configuration ---
PLUGIN_NAME="Jellyfin.Plugin.FinTube"
PROJECT_PATH="${PLUGIN_NAME}/${PLUGIN_NAME}.csproj"
META_JSON="Assets/meta.json"
MANIFEST_JSON="manifest.json"
DIST_DIR="dist"
PUBLISH_DIR="publish"

# Repository settings for manifest URLs
REPO_OWNER="warreth"
REPO_NAME="FinTubeExtended"

# --- Input Validation ---
VERSION=$1
CHANGELOG="${2:-Update}"

if [ -z "$VERSION" ]; then
    echo "Usage: ./build-plugin.sh <VERSION> [CHANGELOG]"
    echo "Example: ./build-plugin.sh 1.0.0 \"Initial release\""
    exit 1
fi

# --- Update Version in Files ---
echo ">>> Updating version to $VERSION..."

# 1. Update .csproj
# Using sed to replace the Version tag
sed -i "s|<Version>.*</Version>|<Version>$VERSION</Version>|" "$PROJECT_PATH"

# 2. Update Assets/meta.json
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# We need a temp file for jq
jq --arg version "$VERSION" \
   --arg changelog "$CHANGELOG" \
   --arg timestamp "$TIMESTAMP" \
   '.version = $version | .changelog = $changelog | .timestamp = $timestamp' \
   "$META_JSON" > "${META_JSON}.tmp" && mv "${META_JSON}.tmp" "$META_JSON"

# --- Build & Package ---
echo ">>> Building $PLUGIN_NAME..."

# Clean up
rm -rf "$DIST_DIR" "$PUBLISH_DIR"

# Build
dotnet publish "$PROJECT_PATH" -c Release -o "$DIST_DIR"

# Package
echo ">>> Packaging ${PLUGIN_NAME}.dll..."
ZIP_NAME="${PLUGIN_NAME}_${VERSION}.zip"
mkdir -p "$PUBLISH_DIR"
cd "$DIST_DIR"
# Only zip the main DLL as requested (Jellyfin guidelines: minimal artifacts)
zip "../$PUBLISH_DIR/$ZIP_NAME" "${PLUGIN_NAME}.dll"
cd ..

echo "✅ Package created at $PUBLISH_DIR/$ZIP_NAME"

# --- Update Manifest ---
echo ">>> Updating $MANIFEST_JSON..."

# Calculate Checksum
CHECKSUM=$(md5sum "$PUBLISH_DIR/$ZIP_NAME" | cut -d ' ' -f 1)
TARGET_ABI=$(jq -r '.targetAbi' "$META_JSON")
SOURCE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/v${VERSION}/${ZIP_NAME}"

# Create new version object
NEW_VERSION_JSON=$(jq -n \
  --arg version "$VERSION" \
  --arg changelog "$CHANGELOG" \
  --arg targetAbi "$TARGET_ABI" \
  --arg sourceUrl "$SOURCE_URL" \
  --arg checksum "$CHECKSUM" \
  --arg timestamp "$TIMESTAMP" \
  '{version: $version, changelog: $changelog, targetAbi: $targetAbi, sourceUrl: $sourceUrl, checksum: $checksum, timestamp: $timestamp}')

# Prepend to the first plugin's versions array in manifest.json
jq --argjson newVersion "$NEW_VERSION_JSON" '.[0].versions = [$newVersion] + .[0].versions' "$MANIFEST_JSON" > "${MANIFEST_JSON}.tmp" && mv "${MANIFEST_JSON}.tmp" "$MANIFEST_JSON"

echo "✅ Manifest updated!"

