#!/bin/sh
set -e

echo "--- 1. Injecting Configuration ---"

if [ -f "$SOURCE_CONFIG_PATH" ]; then
    echo "Found external configuration mounted at $SOURCE_CONFIG_PATH."
    CONFIG_TO_USE="$SOURCE_CONFIG_PATH"
elif [ -f "$DEFAULT_CONFIG_PATH" ]; then
    echo "External configuration not found. Using internal default config."
    CONFIG_TO_USE="$DEFAULT_CONFIG_PATH"
else
    echo "FATAL ERROR: No configuration file (external or default) could be found."
    exit 1
fi

export CONFIG_TO_USE

echo "Chosen config file: $CONFIG_TO_USE"