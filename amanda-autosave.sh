#!/bin/bash
#############################################################################
# AMANDA Auto-Save Daemon
# Saves session state every 5 minutes with AMANDA-DATE-TIME-CST format
# 
# Run: amanda-autosave start
# Stop: amanda-autosave stop
# Status: amanda-autosave status
#############################################################################

INTERVAL=300  # 5 minutes in seconds
PID_FILE="/tmp/amanda-autosave.pid"
LOG_FILE="$HOME/.claude/amanda-autosave.log"

get_amanda_id() {
    # CST timezone (UTC-6)
    TZ="America/Chicago" date +"AMANDA-%Y%m%d-%H%M-CST"
}

get_timestamp() {
    TZ="America/Chicago" date -u +"%Y-%m-%dT%H:%M:%S-06:00"
}

save_session() {
    local project_dir="$1"
    local session_file="$project_dir/.claude-session-state.json"
    local amanda_id=$(get_amanda_id)
    local timestamp=$(get_timestamp)
    
    if [ -f "$session_file" ]; then
        # Update existing session file
        if command -v jq &> /dev/null; then
            jq ".last_updated = \"$timestamp\" | .session_id = \"$amanda_id\"" "$session_file" > "${session_file}.tmp" && mv "${session_file}.tmp" "$session_file"
        else
            # Fallback without jq - create backup and update
            cp "$session_file" "$project_dir/.claude-session-backup-$amanda_id.json"
        fi
        echo "[$(TZ="America/Chicago" date)] Saved: $amanda_id in $project_dir" >> "$LOG_FILE"
    fi
}

start_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "AMANDA auto-save already running (PID: $(cat $PID_FILE))"
        return 1
    fi
    
    echo "Starting AMANDA auto-save daemon (every 5 minutes, CST timezone)..."
    
    (
        while true; do
            # Find all projects with session files
            for session_file in $(find "$HOME/projects" -name ".claude-session-state.json" 2>/dev/null); do
                project_dir=$(dirname "$session_file")
                save_session "$project_dir"
            done
            
            # Also check current directory
            if [ -f ".claude-session-state.json" ]; then
                save_session "$(pwd)"
            fi
            
            sleep $INTERVAL
        done
    ) &
    
    echo $! > "$PID_FILE"
    echo "AMANDA auto-save started (PID: $!)"
    echo "Session ID format: AMANDA-YYYYMMDD-HHMM-CST"
    echo "Saving every 5 minutes"
    echo "Log: $LOG_FILE"
}

stop_daemon() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            rm "$PID_FILE"
            echo "AMANDA auto-save stopped"
        else
            rm "$PID_FILE"
            echo "AMANDA auto-save was not running"
        fi
    else
        echo "AMANDA auto-save is not running"
    fi
}

status_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "AMANDA auto-save is running (PID: $(cat $PID_FILE))"
        echo "Last 5 saves:"
        tail -5 "$LOG_FILE" 2>/dev/null || echo "  No saves yet"
    else
        echo "AMANDA auto-save is not running"
    fi
}

case "${1:-status}" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    status)
        status_daemon
        ;;
    restart)
        stop_daemon
        sleep 1
        start_daemon
        ;;
    *)
        echo "AMANDA Auto-Save Daemon"
        echo ""
        echo "Usage: amanda-autosave [start|stop|status|restart]"
        echo ""
        echo "Saves session state every 5 minutes with AMANDA-DATE-TIME-CST format"
        ;;
esac
