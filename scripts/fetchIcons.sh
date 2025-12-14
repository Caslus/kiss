#!/usr/bin/env bash
set -e

echo "--- 2. Icon Pre-fetching ---"

TEMP_CONFIG_FILE="/tmp/config.json.modified" 

mkdir -p "$DESTINATION_ASSETS_DIR"

fetch_custom_logo() {
    echo "   -> Checking for remote customLogo in config..." >&2
    LOGO_URL=$(jq -r '.customLogo | select(type == "string" and length > 0 and startswith("http"))' "$CONFIG_TO_USE")

    if [ -n "$LOGO_URL" ]; then
        echo "   -> Found remote customLogo: $LOGO_URL" >&2
        
        file_extension=$(echo "$LOGO_URL" | sed 's/^[^.]*//g' | awk -F'.' '{print "."$NF}' | sed 's/\.\.\././g') 
        
        LOGO_FILENAME="custom-logo$file_extension"
        local_path="$DESTINATION_ASSETS_DIR/$LOGO_FILENAME"
        
        echo "   -> Downloading to $local_path" >&2
        
        curl --silent --fail --location -o "$local_path" "$LOGO_URL"
        
        if [ $? -ne 0 ]; then
            echo "   -> ERROR: Failed to download customLogo. Keeping original URL." >&2
            return 1
        fi
        
        echo "./assets/$LOGO_FILENAME"
        return 0
    fi
    echo "   -> No remote customLogo found in config." >&2
    return 1
}

# --- Service Icon Fetching Loop ---
jq -r '.services[] | select((.iconUrl | type) == "string" and (.iconUrl | startswith("http"))) | "\(.id)\t\(.iconUrl)"' "$CONFIG_TO_USE" |
while IFS=$'\t' read -r service_id icon_url; do
    
    file_extension=$(echo "$icon_url" | sed 's/^[^.]*//g' | awk -F'.' '{print "."$NF}' | sed 's/\.\.\././g') 
    if [ "$file_extension" = "." ]; then
        file_extension=""
    fi

    local_path="$DESTINATION_ASSETS_DIR/$service_id$file_extension"
    
    echo "   -> Downloading [ID: $service_id] from $icon_url"
    
    curl --silent --fail --location -o "$local_path" "$icon_url"
    
    if [ $? -ne 0 ]; then
        echo "   -> ERROR: Failed to download icon for $service_id. Keeping original URL."
    fi
done

# --- Custom Logo Rewrite Execution ---
if NEW_LOGO_PATH=$(fetch_custom_logo); then
    DOWNLOAD_SUCCESS=0
else
    DOWNLOAD_SUCCESS=1
    NEW_LOGO_PATH=""
fi

# --- Final Config Rewrite with JQ ---
if ! jq --arg new_logo "$NEW_LOGO_PATH" --arg status "$DOWNLOAD_SUCCESS" '
    # Logic 1: Update customLogo property if download was successful
    if ($status | tonumber) == 0 then
        .customLogo = $new_logo
    else
        .
    end
    |
    # Logic 2: Update services array
    .services |= map(
        if (.iconUrl | type) == "string" and (.iconUrl | length > 0) and (.iconUrl | startswith("http")) then
            (.iconUrl | split("/") | last) as $filename |
            
            ($filename | sub("^[^.]*"; "")) as $extension |
            
            # KEY CHANGE: Using ./assets/
            ("./assets/" + .id + $extension) as $newPath |
            
            .iconUrl = $newPath
        else
            .
        end
    )
' "$CONFIG_TO_USE" > "$TEMP_CONFIG_FILE"; then
    
    echo "FATAL ERROR: Failed to process config with jq. Attempting to copy original config and exit..." >&2
    
    if [ -f "$CONFIG_TO_USE" ]; then
        cp "$CONFIG_TO_USE" "$DESTINATION_CONFIG_PATH"
        echo "Original configuration copied to destination." >&2
    else
        echo "Original config file not found! Container is severely misconfigured." >&2
    fi
    exit 1
fi

cp "$TEMP_CONFIG_FILE" "$DESTINATION_CONFIG_PATH"
echo "Configuration updated and saved to: $DESTINATION_CONFIG_PATH"

export CONFIG_TO_USE="$DESTINATION_CONFIG_PATH"