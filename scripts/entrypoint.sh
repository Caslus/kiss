#!/bin/sh
set -e

# --- Configuration Paths ---
export SOURCE_CONFIG_PATH="/app/external/config.json" 
export DEFAULT_CONFIG_PATH="/app/default/config.json"
export DESTINATION_DIR="/usr/share/nginx/html"
export DESTINATION_CONFIG_PATH="$DESTINATION_DIR/config.json"
export SOURCE_ASSETS_PATH="/app/external/assets"
export DESTINATION_ASSETS_DIR="$DESTINATION_DIR/assets"
export CONFIG_TO_USE=""

# --- Execution Flow ---
echo "Starting Entrypoint..."

# 1. Configuration Injection
. /usr/local/bin/scripts/injectConfig.sh

# 2. Icon Pre-fetching
/usr/bin/env bash /usr/local/bin/scripts/fetchIcons.sh

# 3. Local Assets Injection
/usr/local/bin/scripts/injectAssets.sh

# --- Start the Web Server (Nginx) ---
echo "--- All configuration tasks complete. Starting Nginx ---"
exec nginx -g 'daemon off;'