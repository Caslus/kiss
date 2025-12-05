#!/bin/sh
set -e

SOURCE_CONFIG_PATH="/app/external/config.json" 
DEFAULT_CONFIG_PATH="/app/default/config.json"
DESTINATION_CONFIG_PATH="/usr/share/nginx/html/config.json"

echo "Starting Nginx entrypoint..."
CONFIG_TO_USE=""

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

echo "Starting Nginx..."
exec nginx -g 'daemon off;'