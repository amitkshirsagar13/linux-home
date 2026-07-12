#!/bin/bash

# Default values
DEFAULT_LIST_NAME="season.list"
LIST_FILE_NAME="$DEFAULT_LIST_NAME"
TARGET_DIR="$(pwd)"

# Headers required by the host server
REFERER_URL="https://111.90.159.132/"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"

# Function to display help guide
show_help() {
    echo "Unified aria2c Season Downloader"
    echo "========================================"
    echo "Usage: downloadSeasons.sh [options] [input_file]"
    echo ""
    echo "Arguments:"
    echo "  [input_file]         Optional. Name of the list file in the current directory."
    echo "                       Defaults to '$DEFAULT_LIST_NAME' if not specified."
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help message and exit."
    echo ""
    echo "Examples:"
    echo "  downloadSeasons.sh                    # Uses default '$DEFAULT_LIST_NAME' in current folder"
    echo "  downloadSeasons.sh season.2.list      # Uses a custom file named 'season.2.list'"
    echo "  downloadSeasons.sh --help             # Displays this guide"
    echo "========================================"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Error: Unknown option '$1'"
            echo "Use --help to see valid options."
            exit 1
            ;;
        *)
            # Assume any loose argument is the list filename
            LIST_FILE_NAME="$1"
            shift
            ;;
    esac
done

# Resolve the full path based on the current directory
LIST_FILE="$TARGET_DIR/$LIST_FILE_NAME"

# Check if list file exists in the current folder
if [ ! -f "$LIST_FILE" ]; then
    echo "Error: '$LIST_FILE_NAME' not found in your current directory ($TARGET_DIR)."
    echo "Use --help for usage instructions."
    exit 1
fi

mkdir -p "$TARGET_DIR"

echo "========================================"
echo "Starting Unified aria2c Season Downloader"
echo "Using List File:  $LIST_FILE"
echo "Target Directory: $TARGET_DIR"
echo "========================================"

# Read the file line by line sequentially
while IFS= read -r raw_url || [ -n "$raw_url" ]; do
    # Trim whitespace and skip empty lines
    url=$(echo "$raw_url" | xargs)
    [ -z "$url" ] && continue

    # Extract original filename from URL decode logic
    encoded_name=$(basename "$url")
    decoded_name=$(echo -e "${encoded_name//%/\\x}")
    
    # Replace spaces with dots to make it terminal friendly
    clean_filename=$(echo "$decoded_name" | tr ' ' '.')

    echo ""
    echo "Processing: $clean_filename"
    echo "URL: $url"
    
    # Run aria2c directly in the foreground
    aria2c -x16 \
           -s16 \
           -k1M \
           --referer="$REFERER_URL" \
           --user-agent="$USER_AGENT" \
           --dir="$TARGET_DIR" \
           -o "$clean_filename" \
           "$url"

    if [ $? -eq 0 ]; then
        echo "Successfully downloaded: $clean_filename"
    else
        echo "Failed downloading: $clean_filename"
    fi
    echo "----------------------------------------"

done < "$LIST_FILE"

echo "All listed items processed."
