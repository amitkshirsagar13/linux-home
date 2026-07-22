#!/bin/bash

set -e

VERBOSE=false
FOLDER=""
EXTENSION="mp4"
URL=""

usage() {
    echo "Usage: $0 [OPTIONS] URL"
    echo ""
    echo "Options:"
    echo "  -f <folder>     Output folder"
    echo "  -e <extension>  File extension (default: mp4)"
    echo "  -v              Enable aria2c debug logging"
    echo "  -h              Show help"
    exit 1
}

while getopts ":f:e:vh" opt; do
    case $opt in
        f)
            FOLDER="$OPTARG"
            ;;
        e)
            EXTENSION="$OPTARG"
            ;;
        v)
            VERBOSE=true
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument"
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

# Remaining non-option argument should be URL
for arg in "$@"; do
    if [[ "$arg" =~ ^https?:// ]]; then
        URL="$arg"
        break
    fi
done

if [ -z "$URL" ]; then
    echo "Error: URL is required"
    usage
fi

if [ -z "$FOLDER" ]; then
    FOLDER=$(pwd)
else
    mkdir -p "$FOLDER"
    FOLDER=$(realpath "$FOLDER")
fi

FOLDER_NAME=$(basename "$FOLDER")

FILE_NAME="${FOLDER_NAME}.${EXTENSION}"

REFERER_URL=$(echo "$URL" | grep -oP '^https?://[^/]+/?')

USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

ARIA2_ARGS=(
    -x4
    -s4
    -k1M
    --timeout=30
    --connect-timeout=10
    --referer="$REFERER_URL"
    --header="User-Agent: $USER_AGENT"
    --header="Accept: */*"
    --dir="$FOLDER"
    --retry-wait=5
    -o "$FILE_NAME"
)

if [ "$VERBOSE" = true ]; then
    ARIA2_ARGS+=(
        --console-log-level=debug
        --log-level=debug
        --summary-interval=1
        --log="${FOLDER}/aria2c.log"
    )
fi

CMD=(
    aria2c
    "${ARIA2_ARGS[@]}"
    "$URL"
)

echo "Downloading to folder : $FOLDER"
echo "Output file           : $FILE_NAME"

if [ "$VERBOSE" = true ]; then
    echo "Verbose log           : ${FOLDER}/aria2c.log"
fi

echo ""
echo "Final command:"
printf '%q ' "${CMD[@]}"
echo
echo ""

"${CMD[@]}"
