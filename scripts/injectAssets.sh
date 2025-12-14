#!/bin/sh
set -e

echo "--- 3. Injecting Local Assets ---"

if [ -d "$SOURCE_ASSETS_PATH" ]; then
    echo "Found external assets directory at $SOURCE_ASSETS_PATH."
    mkdir -p "$DESTINATION_ASSETS_DIR"
    echo "Copying whitelisted image files from $SOURCE_ASSETS_PATH..."
    
    find "$SOURCE_ASSETS_PATH" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.svg" -o -iname "*.webp" \) -print0 | while IFS= read -r -d $'\0' file; do
        relative_path="${file#$SOURCE_ASSETS_PATH/}"
        mkdir -p "$(dirname "$DESTINATION_ASSETS_DIR/$relative_path")"
        cp "$file" "$DESTINATION_ASSETS_DIR/$relative_path"
        echo "   - Copied local asset: $relative_path"
    done
    
    echo "Local assets injection complete."
else
    echo "No external assets directory found. Skipping local asset injection."
fi