#!/bin/sh
set -e

echo "Starting Nginx entrypoint..."

# --- Configuration Paths ---
SOURCE_CONFIG_PATH="/app/external/config.json" 
DEFAULT_CONFIG_PATH="/app/default/config.json"
DESTINATION_DIR="/usr/share/nginx/html"
DESTINATION_CONFIG_PATH="$DESTINATION_DIR/config.json"

# --- Assets Paths ---
SOURCE_ASSETS_PATH="/app/external/assets"
DESTINATION_ASSETS_DIR="$DESTINATION_DIR/assets"

echo "Preparing to inject configuration and assets..."
CONFIG_TO_USE=""

# --- Configuration Injection Logic ---
if [ -f "$SOURCE_CONFIG_PATH" ]; then
    echo "Found external configuration mounted at $SOURCE_CONFIG_PATH."
    CONFIG_TO_USE="$SOURCE_CONFIG_PATH"
else
    if [ -f "$DEFAULT_CONFIG_PATH" ]; then
        echo "External configuration not found. Using internal default config."
        CONFIG_TO_USE="$DEFAULT_CONFIG_PATH"
    else
        echo "FATAL ERROR: No configuration file (external or default) could be found."
        exit 1
    fi
fi

echo "Injecting configuration from $CONFIG_TO_USE to $DESTINATION_CONFIG_PATH..."
cp "$CONFIG_TO_USE" "$DESTINATION_CONFIG_PATH"
echo "Configuration successfully injected to: $DESTINATION_CONFIG_PATH"


# --- Assets Injection Logic ---
if [ -d "$SOURCE_ASSETS_PATH" ]; then
    echo "Found external assets directory at $SOURCE_ASSETS_PATH."
    mkdir -p "$DESTINATION_ASSETS_DIR"

    echo "Injecting whitelisted assets to $DESTINATION_ASSETS_DIR..."
    find "$SOURCE_ASSETS_PATH" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.svg" -o -iname "*.webp" \) -print0 | while IFS= read -r -d $'\0' file; do
        relative_path="${file#$SOURCE_ASSETS_PATH/}"
        mkdir -p "$(dirname "$DESTINATION_ASSETS_DIR/$relative_path")"
        cp "$file" "$DESTINATION_ASSETS_DIR/$relative_path"
        echo "   - Copied: $relative_path"
    done
    echo "Assets injection complete. Total files copied: $(find "$DESTINATION_ASSETS_DIR" -type f | wc -l)"
else
    echo "No external assets directory found at $SOURCE_ASSETS_PATH. Skipping asset injection."
fi

# --- Start the Web Server (Nginx) ---
echo "Starting Nginx..."
exec nginx -g 'daemon off;'