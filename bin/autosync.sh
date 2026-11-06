#!/bin/bash
# autosync.sh v3 - event-driven sync; no full tree scans in steady state
#
# Usage: autosync.sh [--full]    (--full forces a full --delete sync at startup)

# # /etc/systemd/system/autosync.service
# [Unit]
# Description=Auto-sync local folder to remote server (Optimized)
# After=network-online.target
# Wants=network-online.target

# [Service]
# Type=simple
# User=kira
# Group=kira
# Environment="HOME=/home/kira"

# # Main service
# ExecStart=/usr/local/bin/autosync.sh

# # Restart on failure
# Restart=on-failure
# RestartSec=30

# # Logging
# StandardOutput=journal
# StandardError=journal
# SyslogIdentifier=autosync

# # Security settings
# PrivateTmp=yes
# NoNewPrivileges=true
# ProtectSystem=strict
# ProtectHome=read-only
# ReadWritePaths=/media/data/xos/actresses/ /var/log

# [Install]
# WantedBy=multi-user.target

# ---------------- Configuration ----------------
LOCAL_DIR="/media/data/xos/actresses/"
REMOTE_HOST="admn@192.168.12.111"
REMOTE_DIR="/media/data/storage/xos/x-linux/pics/acts/"
SSH_KEY="/home/kira/.ssh/id_ed25519"
BATCH_DELAY=5                              # seconds of quiet before syncing a batch
LOG_FILE="/var/log/autosync.log"
STATE_DIR="/var/lib/autosync"              # must be writable by the user running this
FULL_SYNC_INTERVAL=$((7 * 24 * 3600))      # periodic safety full sync (catches offline deletes)
# -------------------------------------------------

[[ "$LOCAL_DIR" != */ ]] && LOCAL_DIR="${LOCAL_DIR}/"
[[ "$REMOTE_DIR" != */ ]] && REMOTE_DIR="${REMOTE_DIR}/"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Starting auto-sync service (v3, event-driven)"
log "Local:  $LOCAL_DIR"
log "Remote: $REMOTE_HOST:$REMOTE_DIR"

if [ ! -f "$SSH_KEY" ]; then
    log "ERROR: SSH key not found at $SSH_KEY"
    exit 1
fi
KEY_PERMS=$(stat -c "%a" "$SSH_KEY" 2>/dev/null)
if [ "$KEY_PERMS" != "600" ]; then
    log "WARNING: SSH key has permissions $KEY_PERMS, fixing"
    chmod 600 "$SSH_KEY" 2>/dev/null || log "ERROR: cannot fix SSH key permissions"
fi

mkdir -p "$STATE_DIR" || { log "ERROR: cannot create $STATE_DIR"; exit 1; }
STAMP="$STATE_DIR/last_sync_stamp"
FULL_STAMP="$STATE_DIR/last_full_sync"

WORK_DIR="/tmp/autosync-$$"
mkdir -p "$WORK_DIR"
PENDING_UPD="$WORK_DIR/pending_upd.txt"     # files to copy (relative paths)
PENDING_DEL="$WORK_DIR/pending_del.txt"     # paths to delete remotely
PENDING_TREE="$WORK_DIR/pending_tree.txt"   # new/moved-in dirs to copy recursively
LAST_CHANGE_FILE="$WORK_DIR/last_change_time"
touch "$PENDING_UPD" "$PENDING_DEL" "$PENDING_TREE"
echo 0 > "$LAST_CHANGE_FILE"

# Reuse one SSH connection for all rsync/ssh calls
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=accept-new -o BatchMode=yes \
-o ControlMaster=auto -o ControlPath=$WORK_DIR/ssh-%C -o ControlPersist=120"
RSYNC_SSH="ssh $SSH_OPTS"

# Don't set owner/group on the remote (common cause of rsync exit 23)
ATTR_OPTS=(--no-o --no-g)

# rsync exit codes: 0 ok, 24 = files vanished (harmless), 23 = partial (warn)
rsync_result() {
    case "$1" in
        0|24) return 0 ;;
        23)   log "  WARN: partial transfer (code 23) - check log above for the files/attrs that failed"; return 23 ;;
        *)    log "  ERROR: rsync failed (code $1)"; return "$1" ;;
    esac
}

# ---------------- Full sync (rare) ----------------
do_full_sync() {
    log "Starting FULL sync (low priority)..."
    local start=$(date +%s)
    touch "$STATE_DIR/stamp.new"
    nice -n 19 ionice -c3 rsync -a --delete "${ATTR_OPTS[@]}" \
        --exclude='*.tmp' --exclude='*.part' --exclude='*.crdownload' \
        -e "$RSYNC_SSH" "$LOCAL_DIR" "$REMOTE_HOST:$REMOTE_DIR" >> "$LOG_FILE" 2>&1
    local rc=$?
    rsync_result $rc
    local res=$?
    log "Full sync finished in $(( $(date +%s) - start ))s (rc=$rc)"
    # Only record success for clean runs, so partial runs get retried
    if [ $rc -eq 0 ] || [ $rc -eq 24 ]; then
        mv -f "$STATE_DIR/stamp.new" "$STAMP"
        touch "$FULL_STAMP"
    else
        rm -f "$STATE_DIR/stamp.new"
    fi
    return $res
}

# ---------------- Catch-up since last run (cheap, local only) ----------------
catch_up() {
    log "Catching up on changes since last sync (local find, no full rsync scan)..."
    touch "$STATE_DIR/stamp.new"
    find "$LOCAL_DIR" -newer "$STAMP" \
        ! -name '*.tmp' ! -name '*.part' ! -name '*.crdownload' \
        -printf '%P\n' 2>/dev/null | grep -v '^$' >> "$PENDING_UPD"
    local n=$(wc -l < "$PENDING_UPD")
    log "  $n changed entries queued"
    # A changed directory may be brand new with contents; do_incremental_sync
    # handles directories via --files-from (non-recursive), and the files
    # inside have their own newer mtimes so they are listed too.
    echo "$(date +%s)" > "$LAST_CHANGE_FILE"
    mv -f "$STATE_DIR/stamp.new" "$STAMP"
}

# ---------------- Incremental batch ----------------
# $1 in-file, $2 out-file, $3 mode: exists | isdir | missing
filter_list() {
    : > "$2"
    sort -u "$1" | while IFS= read -r p; do
        [ -z "$p" ] && continue
        [[ "/$p/" == *"/../"* ]] && continue      # never allow path escape
        local full="${LOCAL_DIR}${p}"
        case "$3" in
            exists)  [[ -e "$full" || -L "$full" ]] && printf '%s\n' "$p" >> "$2" ;;
            isdir)   [[ -d "$full" ]] && printf '%s\n' "$p" >> "$2" ;;
            missing) [[ ! -e "$full" && ! -L "$full" ]] && printf '%s\n' "$p" >> "$2" ;;
        esac
    done
}

do_incremental_sync() {
    [ -s "$PENDING_UPD" ] || [ -s "$PENDING_DEL" ] || [ -s "$PENDING_TREE" ] || return 0

    # Atomically take the current queues; new events go to fresh files
    local b_upd="$WORK_DIR/b_upd" b_del="$WORK_DIR/b_del" b_tree="$WORK_DIR/b_tree"
    mv -f "$PENDING_UPD" "$b_upd"; mv -f "$PENDING_DEL" "$b_del"; mv -f "$PENDING_TREE" "$b_tree"
    touch "$PENDING_UPD" "$PENDING_DEL" "$PENDING_TREE"

    local start=$(date +%s)
    touch "$STATE_DIR/stamp.new"
    local failed=0

    local f_upd="$WORK_DIR/f_upd" f_del="$WORK_DIR/f_del" f_tree="$WORK_DIR/f_tree"
    filter_list "$b_upd"  "$f_upd"  exists
    filter_list "$b_del"  "$f_del"  missing    # skip anything re-created meanwhile
    filter_list "$b_tree" "$f_tree" isdir

    # 1) Deletions (one ssh call, paths passed via stdin, NUL-separated)
    if [ -s "$f_del" ]; then
        log "  → deleting $(wc -l < "$f_del") remote path(s)"
        tr '\n' '\0' < "$f_del" | \
            ssh $SSH_OPTS "$REMOTE_HOST" "cd '$REMOTE_DIR' && xargs -0 -r rm -rf --" >> "$LOG_FILE" 2>&1 \
            || { log "    ✗ remote delete failed"; failed=1; }
    fi

    # 2) New / moved-in directories: recursive, but only that subtree
    while IFS= read -r d; do
        [ -z "$d" ] && continue
        log "  → subtree: $d"
        rsync -aR "${ATTR_OPTS[@]}" -e "$RSYNC_SSH" \
            "${LOCAL_DIR}./${d}" "$REMOTE_HOST:$REMOTE_DIR" >> "$LOG_FILE" 2>&1
        rsync_result $? || [ $? -eq 23 ] || failed=1
    done < "$f_tree"

    # 3) Changed files: only these exact paths, no directory scanning
    if [ -s "$f_upd" ]; then
        log "  → copying $(wc -l < "$f_upd") changed path(s)"
        rsync -lpt "${ATTR_OPTS[@]}" --files-from="$f_upd" -e "$RSYNC_SSH" \
            "$LOCAL_DIR" "$REMOTE_HOST:$REMOTE_DIR" >> "$LOG_FILE" 2>&1
        local rc=$?
        rsync_result $rc || [ $rc -eq 23 ] || failed=1
    fi

    if [ $failed -eq 0 ]; then
        mv -f "$STATE_DIR/stamp.new" "$STAMP"
        log "✓ Batch synced in $(( $(date +%s) - start ))s"
    else
        rm -f "$STATE_DIR/stamp.new"
        log "✗ Batch had errors (will be re-covered by next catch-up / full sync)"
    fi
    return 0
}

# ---------------- Startup ----------------
NEED_FULL=false
if [ "$1" = "--full" ] || [ ! -f "$STAMP" ] || [ ! -f "$FULL_STAMP" ]; then
    NEED_FULL=true
else
    AGE=$(( $(date +%s) - $(stat -c %Y "$FULL_STAMP") ))
    [ "$AGE" -ge "$FULL_SYNC_INTERVAL" ] && NEED_FULL=true
fi

if $NEED_FULL; then
    do_full_sync
    rc=$?
    # 23 is non-fatal. Only bail out on hard failures (ssh/connection errors etc.)
    if [ $rc -ne 0 ] && [ $rc -ne 23 ]; then
        log "ERROR: initial sync failed hard (rc=$rc) - exiting"
        rm -rf "$WORK_DIR"
        exit 1
    fi
else
    catch_up
fi

# ---------------- Scheduler ----------------
sync_scheduler() {
    while true; do
        sleep 1
        if [ -s "$PENDING_UPD" ] || [ -s "$PENDING_DEL" ] || [ -s "$PENDING_TREE" ]; then
            last_change=$(cat "$LAST_CHANGE_FILE" 2>/dev/null || echo 0)
            if [ $(( $(date +%s) - last_change )) -ge "$BATCH_DELAY" ]; then
                do_incremental_sync
            fi
        fi
    done
}
sync_scheduler &
SCHEDULER_PID=$!

CLEANED=false
cleanup() {
    $CLEANED && return
    CLEANED=true
    log "Shutting down auto-sync service..."
    kill "$SCHEDULER_PID" 2>/dev/null
    wait "$SCHEDULER_PID" 2>/dev/null
    do_incremental_sync
    ssh $SSH_OPTS -O exit "$REMOTE_HOST" 2>/dev/null
    rm -rf "$WORK_DIR"
    log "Service stopped"
}
trap 'cleanup; exit 0' SIGTERM SIGINT
trap cleanup EXIT

# ---------------- Watch ----------------
log "Monitoring $LOCAL_DIR"
log "========================================="

# close_write = file finished writing (queued once, not on every modify chunk)
inotifywait -m -r \
    -e close_write,create,delete,moved_from,moved_to \
    --exclude '\.crdownload$|\.tmp$|\.part$' \
    --format '%e %w%f' \
    "$LOCAL_DIR" 2>&1 |
while read -r EVENT FILE; do
    case "$EVENT" in
        Setting|Watches) continue ;;
    esac

    REL="${FILE#$LOCAL_DIR}"
    [ -z "$REL" ] && continue

    case "$EVENT" in
        CREATE,ISDIR|MOVED_TO,ISDIR)
            echo "$REL" >> "$PENDING_TREE" ;;
        DELETE,ISDIR|MOVED_FROM,ISDIR|DELETE|MOVED_FROM)
            echo "$REL" >> "$PENDING_DEL" ;;
        CLOSE_WRITE*|CREATE|MOVED_TO)
            echo "$REL" >> "$PENDING_UPD" ;;
        *)
            # Surfaces inotify errors, e.g. "Failed to watch ... limit reached"
            log "inotify: $EVENT $FILE"
            continue ;;
    esac

    log "Change: $EVENT -> $REL"
    date +%s > "$LAST_CHANGE_FILE"
done
