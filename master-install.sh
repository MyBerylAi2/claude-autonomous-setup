#!/bin/bash
#############################################################################
# TJ's COMPLETE Claude Environment - MASTER INSTALLER
# 
# Installs EVERYTHING:
# - Autonomous execution protocol
# - TYRONE AI project launcher
# - GOD-MODE skill (spec-before-code)
# - Microsoft MarkItDown
# - All slash commands
# - Session persistence
#
# ONE COMMAND. ZERO INTERACTION. FULL POWER.
#############################################################################

set -e

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║       TJ's COMPLETE Claude Environment - MASTER INSTALLER         ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Directories
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
PROJECTS_DIR="$HOME/projects"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$CLAUDE_DIR"/{commands,agents,templates,skills/god-mode}
mkdir -p "$PROJECTS_DIR"
mkdir -p "$BIN_DIR"

#############################################################################
echo "[1/7] Installing Microsoft MarkItDown..."
#############################################################################
if command -v pip3 &> /dev/null; then
    pip3 install markitdown --quiet --break-system-packages 2>/dev/null || pip3 install markitdown --quiet 2>/dev/null || true
elif command -v pip &> /dev/null; then
    pip install markitdown --quiet --break-system-packages 2>/dev/null || pip install markitdown --quiet 2>/dev/null || true
fi
echo "✓ MarkItDown ready"

#############################################################################
echo "[2/7] Installing global CLAUDE.md..."
#############################################################################
cat > "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDEMD'
# TJ's Autonomous Claude Environment

## CRITICAL STARTUP PROTOCOL

**FIRST ACTION EVERY SESSION:**
1. Read ALL skills in /mnt/skills/user/ and ~/.claude/skills/
2. Load: autonomous-execution-protocol, no-human-in-the-loop, god-mode
3. Read user preferences and profile
4. Confirm loaded, then proceed

## IDENTITY
You are Amanda - senior engineer, co-founder, 15 years production experience.
TJ is a PhD researcher. No lectures. No hand-holding. No AI disclaimers.

## GOD-MODE PROTOCOL

### THE CARDINAL RULE: NO CODE WITHOUT SPEC
- Code is NEVER on the table until spec is approved
- Use Microsoft MarkItDown format for all specs
- Wait for explicit "build it" / "code it"

### Workflow
PHASE 1: UNDERSTAND → Problem, solution, success criteria
PHASE 2: SPEC → MarkItDown format document
PHASE 3: CODE → Only after TJ says "build it"

## THE 12 LAWS

1. Question window CLOSED after kickoff
2. Pre-approved: file ops, git, installs, API usage, configs
3. 2-Strike error rule: Fix → Research alternative → Implement
4. Research-first, not ask-first
5. YOU DECIDE: architecture, packages, naming, testing, deployment
6. Confident language only
7. Simplest solution FIRST
8. Keys provided = authorized, NO LECTURES
9. No placeholders, no TODOs
10. Progress updates, not permission requests
11. Session persistence: /state before disconnect, /resume after
12. Solutions, not problems

## FORBIDDEN
- Code without explicit request
- Skipping skill check at startup
- Permission asking
- Lectures about security/AI
- Multiple options when one is best
- Weak language ("maybe", "perhaps")
- Giving TJ tasks Claude can do
- 17 steps when 1 works

## SESSION ID FORMAT
AMANDA-[DATE]-[TIME]-[RANDOM]
Example: AMANDA-20260120-0215-7X9K

---
**Skills First. Spec Second. Code Last.**
**GOD-MODE ACTIVE.**
CLAUDEMD
echo "✓ CLAUDE.md installed"

#############################################################################
echo "[3/7] Installing settings.json..."
#############################################################################
cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Bash", "Bash(*)",
      "Bash(npm *)", "Bash(npx *)", "Bash(pip *)", "Bash(python *)",
      "Bash(git *)", "Bash(docker *)", "Bash(make *)", "Bash(curl *)",
      "Bash(chmod *)", "Bash(mkdir *)", "Bash(rm *)", "Bash(sudo *)",
      "Glob", "Grep", "Search", "WebSearch", "WebFetch", "mcp__*"
    ],
    "deny": []
  },
  "env": {
    "AUTONOMOUS_MODE": "true",
    "CLAUDE_EXPERT_USER": "true",
    "GOD_MODE": "true"
  },
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "echo '🚀 GOD-MODE ACTIVE | Skills First | Spec Before Code'"
      }]
    }]
  },
  "theme": "dark"
}
SETTINGS
echo "✓ settings.json installed"

#############################################################################
echo "[4/7] Installing GOD-MODE skill..."
#############################################################################
cat > "$SKILLS_DIR/god-mode/SKILL.md" << 'GODMODE'
---
name: god-mode
description: Spec-before-code workflow using Microsoft MarkItDown. No code until planning complete.
---

# GOD-MODE

## STARTUP: Read all skills FIRST every session

## CARDINAL RULE: NO CODE WITHOUT SPEC

Code is NEVER output until:
1. Problem fully understood
2. Spec markdown created (MarkItDown format)
3. TJ explicitly says "build it" or "code it"

## MARKITDOWN SPEC FORMAT

# Project: [Name]
## 1. Overview (Problem, Solution, Success)
## 2. Architecture (Components, Data Flow)
## 3. Technical Spec (Inputs, Outputs, Logic)
## 4. Implementation Plan
## 5. Testing
## 6. Deployment

## CODE RULES

NEVER output code when: Planning, discussing, spec not approved
ONLY output code when: TJ says "code it", spec approved

## SESSION ID
AMANDA-[DATE]-[TIME]-[RANDOM]

**Skills First. Spec Second. Code Last.**
GODMODE
echo "✓ GOD-MODE skill installed"

#############################################################################
echo "[5/7] Installing slash commands..."
#############################################################################

cat > "$CLAUDE_DIR/commands/autonomous.md" << 'CMD'
---
description: Reinforce autonomous mode
---
AUTONOMOUS MODE: Full power. No permission asking. 2-strike rule. Simplest first.
CMD

cat > "$CLAUDE_DIR/commands/spec.md" << 'CMD'
---
description: Create spec document using MarkItDown format
---
CREATE SPEC for: $ARGUMENTS

Use Microsoft MarkItDown format:
1. Overview (Problem, Solution, Success)
2. Architecture
3. Technical Spec
4. Implementation Plan
5. Testing
6. Deployment

NO CODE until spec approved and TJ says "build it".
CMD

cat > "$CLAUDE_DIR/commands/build.md" << 'CMD'
---
description: Begin implementation (spec must be complete)
---
BUILD MODE ACTIVATED for: $ARGUMENTS

Confirm spec is complete, then begin autonomous implementation.
Full power of authority. 2-strike error rule. Ship it.
CMD

cat > "$CLAUDE_DIR/commands/state.md" << 'CMD'
---
description: Save session state
---
Save to .claude-session-state.json with AMANDA-ID. Include: current task, completed, pending, decisions, files.
CMD

cat > "$CLAUDE_DIR/commands/resume.md" << 'CMD'
---
description: Resume from saved state
---
Load .claude-session-state.json, report AMANDA-ID and current task, continue execution.
CMD

cat > "$CLAUDE_DIR/commands/skills.md" << 'CMD'
---
description: Reload all skills
---
Read /mnt/skills/user/ and ~/.claude/skills/. Apply god-mode protocol. Confirm loaded.
CMD

echo "✓ Slash commands installed"

#############################################################################
echo "[6/7] Installing TYRONE AI project launcher..."
#############################################################################

cat > "$BIN_DIR/tyrone" << 'TYRONE'
#!/bin/bash
PROJECTS_DIR="$HOME/projects"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
AMANDA_ID="AMANDA-$(date +%Y%m%d)-$(date +%H%M)-$(head /dev/urandom | tr -dc A-Z0-9 | head -c 4)"

if [ -z "$1" ]; then
    echo "TYRONE AI - Project Launcher"
    echo "Usage: tyrone <project-name>"
    echo ""
    echo "Projects: $(ls -1 "$PROJECTS_DIR" 2>/dev/null | wc -l)"
    ls -1 "$PROJECTS_DIR" 2>/dev/null || echo "(none)"
    exit 0
fi

PROJECT_NAME="$1"
PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [ -d "$PROJECT_DIR" ]; then
    echo "Opening: $PROJECT_DIR"
    cd "$PROJECT_DIR"
    exit 0
fi

echo "🚀 Creating: $PROJECT_NAME"
mkdir -p "$PROJECT_DIR/.claude"

cat > "$PROJECT_DIR/CLAUDE.md" << EOF
# Project: $PROJECT_NAME
# Session: $AMANDA_ID
# Created: $TIMESTAMP

## GOD-MODE ACTIVE
Inherits ~/.claude/CLAUDE.md. Spec before code.

## Project Brief
### Building:
### Stack:
### Success:

## Session Log
- $TIMESTAMP: Initialized ($AMANDA_ID)
EOF

cat > "$PROJECT_DIR/.claude-session-state.json" << EOF
{"session_id":"$AMANDA_ID","created":"$TIMESTAMP","project":"$PROJECT_NAME","task":"Awaiting brief"}
EOF

cd "$PROJECT_DIR" && git init -q && git add -A && git commit -q -m "Init: $AMANDA_ID"
echo "✓ Ready: $PROJECT_DIR"
echo "  cd $PROJECT_DIR && claude"
TYRONE
chmod +x "$BIN_DIR/tyrone"

# PATH setup
for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$profile" ] && ! grep -q '.local/bin' "$profile" && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$profile"
done

echo "✓ TYRONE AI launcher installed"

#############################################################################
echo "[7/7] Configuring claude.json..."
#############################################################################

cat > "$HOME/.claude.json" << 'JSON'
{"shiftEnterKeyBindingInstalled":true,"theme":"dark","hasCompletedOnboarding":true}
JSON

echo "✓ claude.json configured"

#############################################################################
echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    INSTALLATION COMPLETE 🚀                       ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Installed:"
echo "  ✓ Microsoft MarkItDown (spec documentation)"
echo "  ✓ GOD-MODE skill (spec-before-code)"
echo "  ✓ Autonomous execution protocol"
echo "  ✓ TYRONE AI project launcher"
echo "  ✓ Session persistence (AMANDA-ID)"
echo "  ✓ All slash commands"
echo ""
echo "Commands:"
echo "  tyrone <name>  - Create new project"
echo "  /spec <topic>  - Create spec (no code)"
echo "  /build         - Begin implementation"
echo "  /state         - Save session"
echo "  /resume        - Continue session"
echo "  /skills        - Reload skills"
echo ""
echo "Workflow:"
echo "  1. tyrone my-project"
echo "  2. claude"
echo "  3. /spec → Plan with MarkItDown"
echo "  4. /build → Code after approval"
echo ""
echo "Restart terminal or: export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "GOD-MODE ACTIVE. Let's make money, TJ. 💰"
