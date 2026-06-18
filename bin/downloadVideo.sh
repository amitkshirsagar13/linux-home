#!/bin/bash
# */15  * * * * ~/bin/downloadVideo.sh > /dev/null 2>&1

# ─────────────────────────────────────────────
#  Paths & globals
# ─────────────────────────────────────────────
LOCK_FILE=~/Videos/video.lock
LOG_FILE=~/Videos/video_download.log
DOWNLOAD_FILE=~/Videos/songs.txt
DOWNLOAD_FILE_TMP=~/Videos/songs.txt.tmp
BACK_FILE=~/Videos/back.songs.txt
SONGS_DIR=/media/zbox/Crucial-X6/ShareMe/media/songs/target
TMP_DIR=~/tmp
TRACKER_FILE=$(mktemp -p "$TMP_DIR")

YT_DLP=~/bin/yt-dlp

# ─────────────────────────────────────────────
#  Logging
# ─────────────────────────────────────────────
log() {
    echo "$*" | tee -a "$LOG_FILE"
}

# ─────────────────────────────────────────────
#  Lock management
# ─────────────────────────────────────────────
acquire_lock() {
    if [ -f "$LOCK_FILE" ]; then
        log "Lock file exists, another instance is running. Exiting."
        exit 0
    fi
    touch "$LOCK_FILE"
}

release_lock() {
    rm -f "$LOCK_FILE"
}

# ─────────────────────────────────────────────
#  Map LANG → DLANG  (case-insensitive)
# ─────────────────────────────────────────────
resolve_dlang() {
    local lang
    lang=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    case "$lang" in
        hindi)                          echo "Hindi"   ;;
        marathi)                        echo "Marathi" ;;
        telugu|tamil|kannada|malyalam|malayalam) echo "South"   ;;
        bhojpuri)                       echo "Bhojpuri" ;;
        english)                        echo "English" ;;
        *)                              echo "Hindi"   ;;   # sensible default
    esac
}

# ─────────────────────────────────────────────
#  Map VFORMAT number → RESOLUTION label
# ─────────────────────────────────────────────
resolve_resolution() {
    local vformat="$1"
    if   [ "$vformat" -lt  720 ]; then echo "sd"
    elif [ "$vformat" -le 1080 ]; then echo "hd"
    else                               echo "xhd"
    fi
}

# ─────────────────────────────────────────────
#  Query available formats and return the best
#  format-id for the requested resolution.
#
#  Strategy:
#    1. Collect all video-only lines from -F output.
#    2. Keep rows whose height == VFORMAT; if none,
#       keep the row whose height is closest.
#    3. Among candidates pick the one with the
#       smallest file size (filesize or filesize_approx).
#
#  Prints a single yt-dlp format id string, e.g. "137"
# ─────────────────────────────────────────────
select_video_format() {
    local url="$1"
    local vformat="$2"

    # Fetch format list (tab-separated machine-readable output)
    # Columns: format_id ext resolution note filesize filesize_approx vcodec acodec
    local fmt_list
    fmt_list=$("$YT_DLP" --cookies-from-browser chrome --js-runtimes node \
        -F "$url" 2>/dev/null)

    if [ -z "$fmt_list" ]; then
        log "  [WARN] Could not retrieve format list for: $url"
        echo ""
        return 1
    fi

    # Parse: lines that have a numeric height (video-only or video+audio)
    # We look for lines containing the target height (e.g. "1080p", "720p", "480p")
    # yt-dlp -F output example:
    #   137  mp4   1920x1080  1080p 3108k , avc1.640028, 30fps, video only, 120.23MiB
    #   251  webm  audio only opus  128k , opus stereo, 3.45MiB

    # Build a simple scored list: id|height|size
    local candidates=""
    while IFS= read -r line; do
        # Skip header / audio-only / storyboard lines
        echo "$line" | grep -qiE '(audio only|storyboard|images)' && continue
        [[ "$line" =~ ^[0-9] ]] || continue

        local id height size_mb
        id=$(echo "$line" | awk '{print $1}')

        # Extract height from resolution field like 1920x1080 or from label like 1080p
        height=$(echo "$line" | grep -oP '\b([0-9]+)(?=p\b)' | head -1)
        [ -z "$height" ] && height=$(echo "$line" | grep -oP '(?<=x)[0-9]+' | head -1)
        [ -z "$height" ] && continue   # can't determine height, skip

        # Extract size: prefer explicit MiB, then KiB, then approx (~)
        size_mb=$(echo "$line" | grep -oP '[~]?\s*[0-9]+(\.[0-9]+)?\s*MiB' | grep -oP '[0-9]+(\.[0-9]+)?' | head -1)
        if [ -z "$size_mb" ]; then
            local size_kib
            size_kib=$(echo "$line" | grep -oP '[~]?\s*[0-9]+(\.[0-9]+)?\s*KiB' | grep -oP '[0-9]+(\.[0-9]+)?' | head -1)
            [ -n "$size_kib" ] && size_mb=$(echo "scale=3; $size_kib/1024" | bc)
        fi
        [ -z "$size_mb" ] && size_mb=999999   # unknown size → sort last

        candidates="${candidates}${id}|${height}|${size_mb}\n"
    done <<< "$fmt_list"

    if [ -z "$candidates" ]; then
        log "  [WARN] No parseable video formats found for: $url"
        echo ""
        return 1
    fi

    # Find exact height matches first
    local exact
    exact=$(printf "%b" "$candidates" | awk -F'|' -v h="$vformat" '$2==h {print}')

    local pool
    if [ -n "$exact" ]; then
        pool="$exact"
    else
        # Find the closest height (minimise |height - vformat|)
        local best_diff=999999 best_height=""
        while IFS='|' read -r id height size; do
            local diff=$(( height > vformat ? height - vformat : vformat - height ))
            if [ "$diff" -lt "$best_diff" ]; then
                best_diff=$diff
                best_height=$height
            fi
        done < <(printf "%b" "$candidates" | awk -F'|' '{print}')
        pool=$(printf "%b" "$candidates" | awk -F'|' -v h="$best_height" '$2==h {print}')
    fi

    # From the pool, pick the entry with the smallest file size
    local best_id
    best_id=$(printf "%b" "$pool" | awk -F'|' 'BEGIN{min=999999;id=""} {if($3<min){min=$3;id=$1}} END{print id}')

    echo "$best_id"
}

# ─────────────────────────────────────────────
#  Select best audio-only format (highest quality
#  audio, smallest size among tied quality).
# ─────────────────────────────────────────────
select_audio_format() {
    local url="$1"
    local fmt_list
    fmt_list=$("$YT_DLP" --cookies-from-browser chrome --js-runtimes node \
        -F "$url" 2>/dev/null)

    # Prefer opus/m4a audio-only; fall back to "bestaudio"
    local best_id
    best_id=$(echo "$fmt_list" | awk '
        /audio only/ && /opus|m4a/ {
            # extract id (first column) and size
            id=$1
            # pick first match (yt-dlp lists best first for audio)
            if (!found) { found=1; best=id }
        }
        END { print (best ? best : "bestaudio") }
    ')
    echo "$best_id"
}

# ─────────────────────────────────────────────
#  Download one entry
# ─────────────────────────────────────────────
download_entry() {
    local url="$1" vformat="$2" lang="$3" actress="$4"

    log ""
    log "  URL:     $url"
    log "  VFORMAT: $vformat  |  LANG: $lang  |  ACTRESS: $actress"

    # Resolve destination labels
    local dlang resolution move_location
    dlang=$(resolve_dlang "$lang")
    resolution=$(resolve_resolution "$vformat")
    move_location="$SONGS_DIR/$dlang/$resolution/$actress"

    log "  DLANG=$dlang  RESOLUTION=$resolution"
    log "  MOVE → $move_location"

    # Select formats
    local vfmt_id afmt_id
    vfmt_id=$(select_video_format "$url" "$vformat")
    afmt_id=$(select_audio_format  "$url")

    if [ -z "$vfmt_id" ]; then
        log "  [ERROR] Could not determine video format id. Skipping."
        return 1
    fi

    log "  Selected: video=$vfmt_id  audio=$afmt_id"

    # Clear tracker
    > "$TRACKER_FILE"

    # Download
    "$YT_DLP" --cookies-from-browser chrome --js-runtimes node \
        -f "${vfmt_id}+${afmt_id}" \
        --embed-thumbnail \
        --downloader aria2c \
        --downloader-args "aria2c:-x 16 -s 16 -k 1M" \
        --progress-delta 0.5 \
        --progress-template 'download: ━► %(progress._percent_str)s of %(progress._total_bytes_str,progress._total_bytes_estimate_str)s | Speed: %(progress._speed_str)s | ETA: %(progress._eta_str)s' \
        --merge-output-format mp4 -c \
        -o "${TMP_DIR}/%(title)s.%(ext)s" \
        --exec "echo {} > '${TRACKER_FILE}'" \
        "$url" >> "$LOG_FILE" 2>&1

    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log "  [ERROR] yt-dlp exited with code $exit_code"
        return 1
    fi

    # Move to destination
    local downloaded_file
    downloaded_file=$(cat "$TRACKER_FILE" 2>/dev/null)
    if [ -z "$downloaded_file" ] || [ ! -f "$downloaded_file" ]; then
        log "  [ERROR] Tracker file empty or downloaded file not found."
        return 1
    fi

    mkdir -p "$move_location"
    mv "$downloaded_file" "$move_location/"
    local moved_name
    moved_name=$(basename "$downloaded_file")

    log "  [OK] Moved: $moved_name → $move_location/"
    notify-send "Download Completed" "Song '$moved_name' downloaded and moved to $move_location." 2>/dev/null || true

    return 0
}

# ─────────────────────────────────────────────
#  Parse & process the download file
#  Format: URL|VFORMAT|LANG|ACTRESS
#  Missing fields inherit from the previous line.
# ─────────────────────────────────────────────
process_download_file() {
    local prev_vformat="" prev_lang="" prev_actress=""

    while IFS= read -r raw_line || [ -n "$raw_line" ]; do
        # Strip leading/trailing whitespace and skip blank/comment lines
        local line
        line=$(echo "$raw_line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ -z "$line" || "$line" == \#* ]] && continue

        # Split on '|'
        local url vformat lang actress
        IFS='|' read -r url vformat lang actress <<< "$line"

        # Trim each field
        url=$(echo     "$url"     | xargs)
        vformat=$(echo "$vformat" | xargs)
        lang=$(echo    "$lang"    | xargs)
        actress=$(echo "$actress" | xargs)

        # Inherit missing fields from previous entry
        [ -z "$vformat" ] && vformat="$prev_vformat"
        [ -z "$lang"    ] && lang="$prev_lang"
        [ -z "$actress" ] && actress="$prev_actress"

        # Validate mandatory fields
        if [ -z "$url" ]; then
            log "  [SKIP] Empty URL on line: $raw_line"
            continue
        fi
        if [ -z "$vformat" ] || ! [[ "$vformat" =~ ^[0-9]+$ ]]; then
            log "  [SKIP] Invalid or missing VFORMAT '$vformat' for: $url"
            continue
        fi

        # Save as previous for next iteration
        prev_vformat="$vformat"
        prev_lang="$lang"
        prev_actress="$actress"

        log "--- Processing entry ---"
        download_entry "$url" "$vformat" "$lang" "$actress"

    done < "$DOWNLOAD_FILE"
}

# ─────────────────────────────────────────────
#  Backup and rotate the download file
# ─────────────────────────────────────────────
backup_and_rotate() {
    {
        echo "-------------------------------------"
        echo "$(date +"%Y-%m-%d %T")"
        echo "-------------------------------------"
        cat "$DOWNLOAD_FILE"
        echo ""
        echo "-------------------------------------"
        echo "$(date +"%Y-%m-%d %T")"
        echo "-------------------------------------"
    } >> "$BACK_FILE"

    rm -f "$DOWNLOAD_FILE"

    if [ -f "$DOWNLOAD_FILE_TMP" ]; then
        mv "$DOWNLOAD_FILE_TMP" "$DOWNLOAD_FILE"
        log "Rotated $DOWNLOAD_FILE_TMP → $DOWNLOAD_FILE"
    else
        log "No $DOWNLOAD_FILE_TMP found to rotate into $DOWNLOAD_FILE"
    fi
}

USER_ID=$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
export DISPLAY=:0

# ─────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────
main() {
    mkdir -p "$TMP_DIR"

    log "================================================================================================"
    log "File processing started at $(date +"%Y-%m-%d %T")"



    if [ ! -f "$DOWNLOAD_FILE" ]; then
        log "No file $DOWNLOAD_FILE for Processing"
        log "File processing completed at $(date +"%Y-%m-%d %T")"
        log "================================================================================================"
        rm -f "$TRACKER_FILE"
        exit 0
    fi

    acquire_lock
    
    notify-send "Video Download Started" "Processing video downloads..." 2>/dev/null || true
    
    process_download_file

    backup_and_rotate

    release_lock

    rm -f "$TRACKER_FILE"

    log "File processing completed at $(date +"%Y-%m-%d %T")"
    log "================================================================================================"
}

main
