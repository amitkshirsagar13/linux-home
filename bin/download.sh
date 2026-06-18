#!/bin/bash

# Ensure an argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <OK.ru URL or Video ID>"
    exit 1
fi

INPUT="$1"

SONGS_DIR=/media/zbox/Crucial-X6/ShareMe/media/songs/target;

# Create a temporary file to store the exact downloaded path
TRACKER_FILE=$(mktemp -p ~/tmp/)

# Common yt-dlp arguments used in both blocks to track the final file
EXEC_ARG="--exec echo:{} > '$TRACKER_FILE'"

# Check if the input is just a video ID (only numbers)
if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
    echo "Detected Video ID. Proceeding with automatic MP4 download..."
    # Your original manual selection logic
    yt-dlp --cookies-from-browser chrome --js-runtimes node -F "https://ok.ru/video/$INPUT"
    
    read -p "Video Format: " VFORMAT
    #read -p "Audio Format: " AFORMAT
    
    # Directly download using the optimal MP4 format selection
    yt-dlp --cookies-from-browser chrome --js-runtimes node \
       -f "$VFORMAT" --embed-thumbnail \
       --merge-output-format mp4 -c \
       --downloader aria2c \
       --downloader-args "aria2c:-x 16 -s 16 -k 1M" \
       --progress-delta 0.5 \
       --progress-template 'download: ━► %(progress._percent_str)s of %(progress._total_bytes_str,progress._total_bytes_estimate_str)s | Speed: %(progress._speed_str)s | ETA: %(progress._eta_str)s' \
       -o "$HOME/tmp/%(title)s.%(ext)s" \
       --exec "echo {} > '$TRACKER_FILE'" \
       "https://ok.ru/video/$INPUT"
else
    echo "Detected full URL. Proceeding with manual format selection..."
    
    # Your original manual selection logic
    yt-dlp --cookies-from-browser chrome --js-runtimes node -F "$INPUT"
    
    read -p "Video Format: " VFORMAT
    read -p "Audio Format: " AFORMAT
    
    yt-dlp --cookies-from-browser chrome --js-runtimes node \
        -f "$VFORMAT+$AFORMAT" --embed-thumbnail \
        --downloader aria2c \
        --downloader-args "aria2c:-x 16 -s 16 -k 1M" \
        --progress-delta 0.5 \
        --progress-template 'download: ━► %(progress._percent_str)s of %(progress._total_bytes_str,progress._total_bytes_estimate_str)s | Speed: %(progress._speed_str)s | ETA: %(progress._eta_str)s' \
        --merge-output-format mp4 -c \
        -o "$HOME/tmp/%(title)s.%(ext)s" \
        --exec "echo {} > '$TRACKER_FILE'" \
        "$INPUT"
fi

# Move the completed file and clean up
if [ -s "$TRACKER_FILE" ]; then
    DOWNLOADED_FILE=$(cat "$TRACKER_FILE")
    
    if [ -f "$DOWNLOADED_FILE" ]; then
        echo "Moving exact file: $DOWNLOADED_FILE"
        mv "$DOWNLOADED_FILE" .
        echo "Finished move!!!"
    else
        echo "Error: Downloaded file not found at $DOWNLOADED_FILE"
    fi
else
    echo "Error: Could not determine the downloaded file name."
fi

# Clean up tracker file
rm -f "$TRACKER_FILE"
