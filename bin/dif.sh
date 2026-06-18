#!/bin/bash

# Define the input file containing the URLs, folders, and filenames
INPUT_FILE="$HOME/Videos/dif.txt"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

echo "Starting bulk download from $INPUT_FILE using cookies.txt..."

# Read the file line by line, splitting into 3 potential components
while IFS='|' read -r url foldername filename || [ -n "$url" ]; do
    
    # FIX WINDOWS LINE ENDINGS: Strip hidden \r characters and spaces
    url=$(echo "$url" | tr -d '\r' | xargs)
    foldername=$(echo "$foldername" | tr -d '\r' | xargs)
    filename=$(echo "$filename" | tr -d '\r' | xargs)

    # Skip empty lines or comments
    if [[ -z "$url" ]] || [[ "$url" == \#* ]]; then
        continue
    fi

    # BACKWARD COMPATIBILITY: If it's an old 2-column line (url|filename), 
    # the 3rd variable will be empty. We shift the values accordingly.
    if [[ -z "$filename" && -n "$foldername" ]]; then
        filename="$foldername"
        foldername=""
    fi

    # Check if a filename was determined
    if [[ -z "$filename" ]]; then
        echo "Warning: No filename provided for $url. Skipping."
        continue
    fi

    # Determine the platform base directory based on the URL
    if [[ "$url" == *instagram.com* ]]; then
        PLATFORM_DIR="instagram"
    elif [[ "$url" == *facebook.com* ]]; then
        PLATFORM_DIR="facebook"
    else
        PLATFORM_DIR="/media/data/xos/actresses"
    fi

    # Construct the final target directory tree
    if [[ -n "$foldername" ]]; then
        TARGET_DIR="/media/data/xos/actresses/$foldername/$PLATFORM_DIR"
    else
        TARGET_DIR="/media/data/xos/actresses/$PLATFORM_DIR"
    fi

    # Create the directory structure dynamically
    mkdir -p "$TARGET_DIR"

    # Isolate the base name and force the extension to be .mp4
    base_name="${filename%.*}"
    ext=".mp4"

    # Initial target path
    TARGET_PATH="$TARGET_DIR/${base_name}${ext}"
    
    # Check if file name already exists and increment if needed
    counter=1
    while [[ -f "$TARGET_PATH" ]]; do
        TARGET_PATH="$TARGET_DIR/${base_name}_${counter}${ext}"
        ((counter++))
    done

    echo "--------------------------------------------------------"
    echo "Downloading: $url"
    echo "Saving to:   $TARGET_PATH"
    echo "--------------------------------------------------------"

    # Execute yt-dlp with MP4 format constraints and thumbnail embedding
    yt-dlp \
        --cookies ./cookies.txt \
        -f "bv*[ext=mp4]+ba*[ext=m4a]/b[ext=mp4]" \
        --merge-output-format mp4 \
        --embed-thumbnail \
        -o "$TARGET_PATH" \
        "$url"

    # ---- METADATA INJECTION ----
    # If the download was successful, inject the source URL into the MP4 metadata
    if [[ -f "$TARGET_PATH" ]]; then
        echo "Adding URL to video metadata..."
        ffmpeg -y -i "$TARGET_PATH" -c copy -metadata comment="URL: $url" "$TARGET_PATH.tmp.mp4" && \
        mv "$TARGET_PATH.tmp.mp4" "$TARGET_PATH"
    fi
    # ----------------------------

    # Brief pause to respect rate limits
    sleep 3

    notify-send "Download Completed" "Song '$filename' downloaded and moved to $TARGET_PATH." 2>/dev/null || true

done < "$INPUT_FILE"

echo "All downloads completed!"
