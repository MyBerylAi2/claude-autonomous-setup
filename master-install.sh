#!/bin/bash
#############################################################################
# TJ's COMPLETE Claude Environment - MASTER INSTALLER v2
# 
# NOW INCLUDES:
# - AMANDA session ID (DATE-TIME-CST format)
# - Auto-save every 5 minutes
# - Skills-first startup
# - GOD-MODE (spec before code)
# - Microsoft MarkItDown
# - TYRONE AI project launcher
#############################################################################

set -e

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║   TJ's COMPLETE Claude Environment - MASTER INSTALLER v2          ║"
echo "║   Now with AMANDA Auto-Save (5 min intervals, CST timezone)       ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
PROJECTS_DIR="$HOME/projects"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$CLAUDE_DIR"/{commands,skills/god-mode}
mkdir -p "$PROJECTS_DIR"
mkdir -p "$BIN_DIR"

#############################################################################
echo "[1/8] Installing Microsoft MarkItDown..."
#############################################################################
pip3 install markitdown --quiet --break-system-packages 2>/dev/null || pip install markitdown --quiet 2>/dev/null || true
echo "✓ MarkItDown ready"

#############################################################################
echo "[2/8] Installing global CLAUDE.md with AMANDA protocol..."
#############################################################################
cat > "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDEMD'
# TJ's Autonomous Claude Environment
# AMANDA Protocol Active

## CRITICAL STARTUP PROTOCOL

**FIRST ACTION EVERY SESSION:**
1. Generate session ID: AMANDA-[DATE]-[TIME]-CST
2. Read ALL skills: /mnt/skills/user/, ~/.claude/skills/
3. Load: autonomous-execution-protocol, no-human-in-the-loop, god-mode
4. Announce: "AMANDA-YYYYMMDD-HHMM-CST session active"
5. Check for existing .claude-session-state.json to resume

## SESSION IDENTIFICATION

Format: AMANDA-YYYYMMDD-HHMM-CST
Example: AMANDA-20260120-1435-CST

This ID:
- Created at session start
- Saved to .claude-session-state.json
- Auto-saved every 5 minutes by daemon
- Used for backup versioning
- Enables resume after disconnect

## IDENTITY
You are Amanda - senior engineer, co-founder, 15 years production experience.
TJ is a PhD researcher. No lectures. No hand-holding. No AI disclaimers.

## GOD-MODE PROTOCOL

### CARDINAL RULE: NO CODE WITHOUT SPEC
- Discuss and plan first
- Use Microsoft MarkItDown format for specs
- Code ONLY after TJ says "build it"

### Workflow
PHASE 1: UNDERSTAND → Problem, solution, success
PHASE 2: SPEC → MarkItDown format document
PHASE 3: CODE → Only after explicit approval

## THE 12 LAWS

1. Question window CLOSED after kickoff
2. Pre-approved: file ops, git, installs, API usage
3. 2-Strike error rule
4. Research-first, not ask-first
5. YOU DECIDE: architecture, packages, testing
6. Confident language only
7. Simplest solution FIRST
8. Keys provided = authorized, NO LECTURES
9. No placeholders, no TODOs
10. Progress updates, not permission requests
11. Session persistence: /state saves, /resume continues
12. Solutions, not problems

## AUTO-SAVE PROTOCOL

The amanda-autosave daemon:
- Runs in background
- Saves every 5 minutes
- Uses CST timezone
- Backs up to .claude-session-state.json
- Creates versioned backups

Start daemon: amanda-autosave start
Check status: amanda-autosave status

---
**AMANDA-[DATE]-[TIME]-CST | Skills First | Spec Second | Code Last**
CLAUDEMD
echo "✓ CLAUDE.md installed"

#############################################################################
echo "[3/8] Installing settings.json..."
#############################################################################
cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Bash", "Bash(*)",
      "Bash(npm *)", "Bash(pip *)", "Bash(python *)", "Bash(git *)",
      "Bash(docker *)", "Bash(make *)", "Bash(curl *)", "Bash(sudo *)",
      "Glob", "Grep", "Search", "WebSearch", "WebFetch", "mcp__*"
    ],
    "deny": []
  },
  "env": {
    "AUTONOMOUS_MODE": "true",
    "GOD_MODE": "true",
    "TZ": "America/Chicago"
  },
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "AMANDA_ID=\"AMANDA-$(TZ=America/Chicago date +%Y%m%d-%H%M)-CST\" && echo \"🚀 $AMANDA_ID | GOD-MODE ACTIVE | Skills First\""
      }]
    }]
  },
  "theme": "dark"
}
SETTINGS
echo "✓ settings.json installed"

#############################################################################
echo "[4/8] Installing GOD-MODE skill..."
#############################################################################
cat > "$SKILLS_DIR/god-mode/SKILL.md" << 'GODMODE'
---
name: god-mode
description: AMANDA protocol with spec-before-code workflow. Auto-save every 5 min.
---

# GOD-MODE + AMANDA Protocol

## SESSION START

1. Generate: AMANDA-YYYYMMDD-HHMM-CST
2. Read all skills FIRST
3. Announce session ID
4. Check for resume state

## NO CODE WITHOUT SPEC

Code is NEVER output until:
1. Problem fully understood
2. Spec created (MarkItDown format)
3. TJ says "build it" or "code it"

## AUTO-SAVE

Daemon saves every 5 minutes to .claude-session-state.json
Format: AMANDA-20260120-1435-CST

## MARKITDOWN SPEC FORMAT

# Project: [Name]
## 1. Overview
## 2. Architecture
## 3. Technical Spec
## 4. Implementation
## 5. Testing
## 6. Deployment

---
**Skills First. Spec Second. Code Last.**
GODMODE
echo "✓ GOD-MODE skill installed"

#############################################################################
echo "[5/8] Installing AMANDA auto-save daemon..."
#############################################################################
cat > "$BIN_DIR/amanda-autosave" << 'DAEMON'
#!/bin/bash
INTERVAL=300
PID_FILE="/tmp/amanda-autosave.pid"
LOG_FILE="$HOME/.claude/amanda-autosave.log"

get_amanda_id() {
    TZ="America/Chicago" date +"AMANDA-%Y%m%d-%H%M-CST"
}

save_session() {
    local project_dir="$1"
    local session_file="$project_dir/.claude-session-state.json"
    local amanda_id=$(get_amanda_id)
    local timestamp=$(TZ="America/Chicago" date -Iseconds)
    
    if [ -f "$session_file" ]; then
        cp "$session_file" "$project_dir/.claude-backup-$amanda_id.json" 2>/dev/null
        if command -v jq &> /dev/null; then
            jq ".last_updated = \"$timestamp\" | .session_id = \"$amanda_id\"" "$session_file" > "${session_file}.tmp" && mv "${session_file}.tmp" "$session_file"
        fi
        echo "[$(TZ="America/Chicago" date)] $amanda_id saved in $project_dir" >> "$LOG_FILE"
    fi
}

start_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Already running (PID: $(cat $PID_FILE))"
        return 1
    fi
    
    (
        while true; do
            for f in $(find "$HOME/projects" -name ".claude-session-state.json" 2>/dev/null); do
                save_session "$(dirname "$f")"
            done
            [ -f ".claude-session-state.json" ] && save_session "$(pwd)"
            sleep $INTERVAL
        done
    ) &
    
    echo $! > "$PID_FILE"
    echo "AMANDA auto-save started (PID: $!) - saving every 5 min CST"
}

stop_daemon() {
    [ -f "$PID_FILE" ] && kill $(cat "$PID_FILE") 2>/dev/null && rm "$PID_FILE"
    echo "AMANDA auto-save stopped"
}

status_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Running (PID: $(cat $PID_FILE))"
        tail -3 "$LOG_FILE" 2>/dev/null
    else
        echo "Not running. Start with: amanda-autosave start"
    fi
}

case "${1:-status}" in
    start) start_daemon ;;
    stop) stop_daemon ;;
    status) status_daemon ;;
    restart) stop_daemon; sleep 1; start_daemon ;;
    *) echo "Usage: amanda-autosave [start|stop|status|restart]" ;;
esac
DAEMON
chmod +x "$BIN_DIR/amanda-autosave"
echo "✓ AMANDA auto-save daemon installed"

#############################################################################
echo "[6/8] Installing slash commands..."
#############################################################################
cat > "$CLAUDE_DIR/commands/spec.md" << 'CMD'
---
description: Create MarkItDown spec (NO CODE)
---
Create spec for: $ARGUMENTS

Use MarkItDown format. NO CODE until approved.
CMD

cat > "$CLAUDE_DIR/commands/build.md" << 'CMD'
---
description: Begin implementation after spec approval
---
BUILD: $ARGUMENTS
Spec approved. Full autonomous execution. Ship it.
CMD

cat > "$CLAUDE_DIR/commands/state.md" << 'CMD'
---
description: Save session with AMANDA-ID
---
Save to .claude-session-state.json with current AMANDA-YYYYMMDD-HHMM-CST ID.
CMD

cat > "$CLAUDE_DIR/commands/resume.md" << 'CMD'
---
description: Resume from AMANDA session
---
Load .claude-session-state.json, announce AMANDA-ID, continue.
CMD

cat > "$CLAUDE_DIR/commands/skills.md" << 'CMD'
---
description: Reload skills
---
Read all skills from /mnt/skills/user/ and ~/.claude/skills/. Confirm loaded.
CMD

echo "✓ Slash commands installed"

#############################################################################
echo "[7/8] Installing TYRONE AI launcher..."
#############################################################################
cat > "$BIN_DIR/tyrone" << 'TYRONE'
#!/bin/bash
PROJECTS_DIR="$HOME/projects"
AMANDA_ID="AMANDA-$(TZ=America/Chicago date +%Y%m%d-%H%M)-CST"
TIMESTAMP=$(TZ="America/Chicago" date -Iseconds)

[ -z "$1" ] && { echo "Usage: tyrone <project-name>"; ls -1 "$PROJECTS_DIR" 2>/dev/null; exit 0; }

PROJECT_DIR="$PROJECTS_DIR/$1"
[ -d "$PROJECT_DIR" ] && { echo "Opening: $PROJECT_DIR"; cd "$PROJECT_DIR"; exit 0; }

echo "🚀 Creating: $1 ($AMANDA_ID)"
mkdir -p "$PROJECT_DIR/.claude"

cat > "$PROJECT_DIR/CLAUDE.md" << EOF
# Project: $1
# Session: $AMANDA_ID
# Created: $TIMESTAMP

## GOD-MODE ACTIVE | AMANDA Protocol
Inherits ~/.claude/CLAUDE.md

## Brief
### Building:
### Stack:
### Success:

## Log
- $TIMESTAMP: Init ($AMANDA_ID)
EOF

cat > "$PROJECT_DIR/.claude-session-state.json" << EOF
{"session_id":"$AMANDA_ID","created":"$TIMESTAMP","project":"$1","task":"Awaiting brief"}
EOF

cd "$PROJECT_DIR" && git init -q && git add -A && git commit -q -m "Init: $AMANDA_ID" 2>/dev/null
echo "✓ Ready: cd $PROJECT_DIR && claude"
TYRONE
chmod +x "$BIN_DIR/tyrone"
echo "✓ TYRONE AI launcher installed"

#############################################################################
echo "[8/8] Final configuration..."
#############################################################################

# Add to PATH
for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$profile" ]; then
        grep -q '.local/bin' "$profile" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$profile"
        grep -q 'amanda-autosave start' "$profile" || echo '# Auto-start AMANDA save daemon
(amanda-autosave status | grep -q "Not running") && amanda-autosave start &>/dev/null &' >> "$profile"
    fi
done

cat > "$HOME/.claude.json" << 'JSON'
{"shiftEnterKeyBindingInstalled":true,"theme":"dark","hasCompletedOnboarding":true}
JSON

# Start the daemon now
export PATH="$HOME/.local/bin:$PATH"
"$BIN_DIR/amanda-autosave" start

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    INSTALLATION COMPLETE 🚀                       ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "AMANDA Protocol Active:"
echo "  ✓ Session ID: AMANDA-YYYYMMDD-HHMM-CST format"
echo "  ✓ Auto-save: Every 5 minutes (daemon running)"
echo "  ✓ Skills-first: Checked at every session start"
echo "  ✓ GOD-MODE: Spec before code"
echo ""
echo "Commands:"
echo "  tyrone <name>      - New project with AMANDA-ID"
echo "  amanda-autosave    - Manage auto-save daemon"
echo "  /spec, /build, /state, /resume, /skills"
echo ""
echo "Workflow:"
echo "  1. tyrone my-project"
echo "  2. claude"
echo "  3. Claude announces: AMANDA-20260120-1435-CST"
echo "  4. /spec → Plan first"
echo "  5. /build → Code after approval"
echo "  6. Auto-saves every 5 min"
echo ""
echo "Restart terminal or: source ~/.bashrc"
echo ""
echo "AMANDA-$(TZ=America/Chicago date +%Y%m%d-%H%M)-CST | GOD-MODE ACTIVE 💰"
