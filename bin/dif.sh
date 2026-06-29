#!/bin/bash

# =============================================================================
# Configuration
# =============================================================================
INPUT_FILE="$HOME/Videos/dif.txt"
COOKIES_FILE="$HOME/Videos/cookies.txt"
BROWSER="chrome"                    # chrome | firefox | brave | edge | chromium
COOKIES_MAX_AGE_MINUTES=720         # Re-extract if older than this (12 hours)
DOWNLOAD_BASE_DIR="/media/data/xos/actresses"
SLEEP_BETWEEN_DOWNLOADS=3
NOTIFY=true

# =============================================================================
# Logging
# =============================================================================
log_info()    { echo "[INFO]  $*"; }
log_warn()    { echo "[WARN]  $*"; }
log_error()   { echo "[ERROR] $*" >&2; }
log_section() { echo; echo "========================================"; echo "  $*"; echo "========================================"; }

# =============================================================================
# Notifications
# =============================================================================
notify() {
    local title="$1"
    local message="$2"
    if [[ "$NOTIFY" == true ]]; then
        notify-send "$title" "$message" 2>/dev/null || true
    fi
}

# =============================================================================
# Cookie Management
# =============================================================================
cookies_are_fresh() {
    [[ -f "$COOKIES_FILE" ]] && \
    [[ -z "$(find "$COOKIES_FILE" -mmin +"$COOKIES_MAX_AGE_MINUTES" 2>/dev/null)" ]]
}

extract_cookies() {
    log_info "Extracting cookies from $BROWSER..."
    yt-dlp \
        --cookies-from-browser "$BROWSER" \
        --cookies "$COOKIES_FILE" \
        --skip-download \
        "https://www.instagram.com/" 2>/dev/null

    if [[ ! -f "$COOKIES_FILE" ]]; then
        log_error "Failed to extract cookies from $BROWSER."
        log_error "Make sure you are logged into Instagram in $BROWSER."
        return 1
    fi
    log_info "Cookies saved to $COOKIES_FILE"
}

ensure_cookies() {
    if cookies_are_fresh; then
        log_info "Using existing cookies.txt (fresher than ${COOKIES_MAX_AGE_MINUTES}m)."
    else
        [[ -f "$COOKIES_FILE" ]] \
            && log_info "cookies.txt is stale. Refreshing..." \
            || log_info "No cookies.txt found."
        extract_cookies || return 1
    fi
}

# =============================================================================
# Platform Detection
# =============================================================================
get_platform_dir() {
    local url="$1"
    if [[ "$url" == *instagram.com* ]]; then
        echo "instagram"
    elif [[ "$url" == *facebook.com* ]]; then
        echo "facebook"
    else
        echo "other"
    fi
}

# =============================================================================
# Path Resolution
# =============================================================================
resolve_target_path() {
    local foldername="$1"
    local filename="$2"
    local platform_dir="$3"

    local base_dir
    if [[ -n "$foldername" ]]; then
        base_dir="$DOWNLOAD_BASE_DIR/$foldername/$platform_dir"
    else
        base_dir="$DOWNLOAD_BASE_DIR/$platform_dir"
    fi

    mkdir -p "$base_dir"

    local base_name="${filename%.*}"
    local target="$base_dir/${base_name}.mp4"

    local counter=1
    while [[ -f "$target" ]]; do
        target="$base_dir/${base_name}_${counter}.mp4"
        ((counter++))
    done

    echo "$target"
}

# =============================================================================
# Download
# =============================================================================
download_video() {
    local url="$1"
    local target_path="$2"

    yt-dlp \
        --cookies "$COOKIES_FILE" \
        -f "bv*[ext=mp4]+ba*[ext=m4a]/b[ext=mp4]" \
        --merge-output-format mp4 \
        --embed-thumbnail \
        -o "$target_path" \
        "$url"
}

inject_metadata() {
    local url="$1"
    local target_path="$2"

    if [[ ! -f "$target_path" ]]; then
        log_warn "File not found for metadata injection: $target_path"
        return 1
    fi

    log_info "Injecting source URL into metadata..."
    local tmp="${target_path}.tmp.mp4"
    ffmpeg -y -i "$target_path" -c copy \
        -metadata comment="URL: $url" "$tmp" \
        && mv "$tmp" "$target_path" \
        || { log_warn "Metadata injection failed. Original file kept."; rm -f "$tmp"; }
}

process_entry() {
    local url="$1"
    local foldername="$2"
    local filename="$3"

    local platform_dir
    platform_dir="$(get_platform_dir "$url")"

    local target_path
    target_path="$(resolve_target_path "$foldername" "$filename" "$platform_dir")"

    log_section "Downloading"
    log_info "URL:      $url"
    log_info "Folder:   ${foldername:-<none>}"
    log_info "Platform: $platform_dir"
    log_info "Target:   $target_path"

    download_video "$url" "$target_path"
    inject_metadata "$url" "$target_path"

    notify "Download Completed" "File '$filename' saved to $target_path."
    sleep "$SLEEP_BETWEEN_DOWNLOADS"
}

# =============================================================================
# Input Parsing
# =============================================================================
parse_and_process() {
    local prev_foldername=""
    local prev_filename=""
    local line_num=0
    local success=0
    local skipped=0

    while IFS='|' read -r url foldername filename || [[ -n "$url" ]]; do
        ((line_num++))

        # Normalize whitespace and strip Windows line endings
        url=$(echo "$url"        | tr -d '\r' | xargs)
        foldername=$(echo "$foldername" | tr -d '\r' | xargs)
        filename=$(echo "$filename"   | tr -d '\r' | xargs)

        # Skip blank lines and comments
        [[ -z "$url" ]] || [[ "$url" == \#* ]] && continue

        # Inherit previous values for omitted fields
        [[ -z "$foldername" ]] && foldername="$prev_foldername"
        [[ -z "$filename"   ]] && filename="$prev_filename"

        if [[ -z "$filename" ]]; then
            log_warn "Line $line_num: No filename for $url — skipping."
            ((skipped++))
            continue
        fi

        process_entry "$url" "$foldername" "$filename"
        ((success++))

        prev_foldername="$foldername"
        prev_filename="$filename"

    done < "$INPUT_FILE"

    log_section "Summary"
    log_info "Processed: $((success + skipped)) entries"
    log_info "Downloaded: $success"
    log_info "Skipped:    $skipped"
}

# =============================================================================
# Validation
# =============================================================================
validate_inputs() {
    if [[ ! -f "$INPUT_FILE" ]]; then
        log_error "Input file not found: $INPUT_FILE"
        return 1
    fi
    if ! command -v yt-dlp &>/dev/null; then
        log_error "yt-dlp is not installed or not in PATH."
        return 1
    fi
    if ! command -v ffmpeg &>/dev/null; then
        log_error "ffmpeg is not installed or not in PATH."
        return 1
    fi
}

# =============================================================================
# Entry Point
# =============================================================================
main() {
    log_section "Bulk Video Downloader"
    validate_inputs || exit 1
    ensure_cookies  || exit 1
    parse_and_process
    log_info "All done!"
}

main "$@"
