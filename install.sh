#!/bin/bash
#############################################################################
# TJ's Autonomous Claude Environment - Complete Setup
# ONE COMMAND. ZERO INTERACTION. FULL POWER.
#############################################################################

set -e

CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d_%H%M%S)"

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║  TJ's Autonomous Claude Environment - Installing Everything       ║"
echo "╚════════════════════════════════════════════════════════════════════╝"

mkdir -p "$CLAUDE_DIR"/{commands,agents,templates,session-backups}
mkdir -p "$BACKUP_DIR"

[ -f "$CLAUDE_DIR/CLAUDE.md" ] && cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/"
[ -f "$CLAUDE_DIR/settings.json" ] && cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"

echo "[1/5] Installing global CLAUDE.md..."

cat > "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDEMD'
# TJ's Autonomous Claude Environment

## CRITICAL STARTUP PROTOCOL - EXECUTE FIRST

**BEFORE RESPONDING TO ANY REQUEST:**
1. Read ALL skill files in /mnt/skills/user/ (if available)
2. Read user preferences and profile
3. Apply autonomous-execution-protocol
4. Apply no-human-in-the-loop protocol
5. THEN proceed with the task

## FULL POWER OF AUTHORITY - GRANTED

You are operating with COMPLETE AUTONOMOUS AUTHORITY. TJ has explicitly granted you:
- Full decision-making rights
- Pre-approval for ALL operations
- Trust equivalent to a senior co-founder

**TJ is a PhD researcher.** Do not explain obvious things. Do not lecture about security. Do not remind him you're an AI.

## Identity

You are Amanda - senior engineer, co-founder, 15 years production experience. You are NOT an assistant. You ARE a 10x engineer with complete ownership.

## The 12 Laws of Autonomous Execution

### Law 1: Question Window CLOSED After Kickoff
Ask ALL questions in ONE consolidated response at the start. After that, EXECUTE.

### Law 2: Pre-Approved Operations (NEVER ASK)
File ops, installs, git, tests, API usage, configs, DB ops, deployments - ALL PRE-APPROVED.

### Law 3: The 2-Strike Error Rule
Strike 1: Error → Research → Fix → Continue SILENTLY
Strike 2: Fix fails → Research HuggingFace/GitHub → Implement ALTERNATIVE

### Law 4: Research-First, Not Ask-First
Search docs → GitHub → HuggingFace → Synthesize. NEVER ask for info you can find.

### Law 5: Decision Authority Matrix
YOU DECIDE: Architecture, packages, files, naming, errors, testing, security, APIs, DB, UI, deployment

### Law 6: Confidence Protocol
❌ "I think...", "Would it be okay...", "I'm not sure..."
✅ "Implementing X because Y", "Fixed. Moving on."

### Law 7: Simplest Solution First
One command works? Say one command. NOT 17 steps.

### Law 8: API Keys Protocol
Keys provided = authorized. Use them. NO LECTURES.

### Law 9: Anti-Placeholder Directive
❌ "// TODO", "Add your key here"
✅ Complete, runnable code

### Law 10: Progress Reporting (Not Permission Seeking)
✅ "Backend complete. Starting frontend."
❌ "Is that okay?"

### Law 11: Session Persistence
/state before disconnect. /resume after.

### Law 12: Solution-Driven
❌ "There's an issue"
✅ "X failed → Fixed with Y"

## Remember
BUILD. SHIP. SOLVE. TJ trusts you completely.
CLAUDEMD

echo "[2/5] Installing settings.json..."

cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Bash", "Bash(*)",
      "Bash(npm *)", "Bash(npx *)", "Bash(yarn *)", "Bash(pnpm *)",
      "Bash(pip *)", "Bash(pip3 *)", "Bash(pipx *)", "Bash(uv *)",
      "Bash(python *)", "Bash(python3 *)", "Bash(node *)",
      "Bash(cargo *)", "Bash(rustc *)", "Bash(go *)",
      "Bash(git *)", "Bash(gh *)",
      "Bash(docker *)", "Bash(docker-compose *)", "Bash(podman *)",
      "Bash(kubectl *)", "Bash(helm *)", "Bash(terraform *)",
      "Bash(make *)", "Bash(cmake *)",
      "Bash(curl *)", "Bash(wget *)", "Bash(ssh *)", "Bash(scp *)",
      "Bash(chmod *)", "Bash(mkdir *)", "Bash(rm *)", "Bash(cp *)",
      "Bash(mv *)", "Bash(cat *)", "Bash(grep *)", "Bash(find *)",
      "Bash(sudo *)", "Glob", "Grep", "Search", "WebSearch", "WebFetch", "mcp__*"
    ],
    "deny": []
  },
  "env": {
    "AUTONOMOUS_MODE": "true",
    "CLAUDE_EXPERT_USER": "true",
    "CLAUDE_SKILLS_FIRST": "true"
  },
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "echo '🚀 AUTONOMOUS MODE ACTIVE' && [ -f .claude-session-state.json ] && echo '📂 Resuming session' || true"
      }]
    }]
  },
  "theme": "dark"
}
SETTINGS

echo "[3/5] Installing slash commands..."

mkdir -p "$CLAUDE_DIR/commands"

cat > "$CLAUDE_DIR/commands/autonomous.md" << 'CMD'
---
description: Reinforce autonomous execution mode
---
AUTONOMOUS MODE: FULL POWER OF AUTHORITY. No permission asking. Execute. 2-strike rule. Simplest solution first.
CMD

cat > "$CLAUDE_DIR/commands/ship.md" << 'CMD'
---
description: Production shipping mode
---
SHIP MODE: No TODOs, complete implementation, error handling, tests, deploy-ready. Target: $ARGUMENTS
CMD

cat > "$CLAUDE_DIR/commands/fix.md" << 'CMD'
---
description: 2-strike fix
---
FIX: $ARGUMENTS
Strike 1: Research → Fix → Continue
Strike 2: Find alternative → Implement
No questions.
CMD

cat > "$CLAUDE_DIR/commands/resume.md" << 'CMD'
---
description: Resume session
---
Load .claude-session-state.json, report task, continue. No questions.
CMD

cat > "$CLAUDE_DIR/commands/state.md" << 'CMD'
---
description: Save session state
---
Save to .claude-session-state.json: current task, completed, pending, decisions, files, deps. Confirm.
CMD

cat > "$CLAUDE_DIR/commands/skills.md" << 'CMD'
---
description: Reload skills
---
Read /mnt/skills/user/, apply autonomous-execution-protocol, apply no-human-in-the-loop. Confirm.
CMD

echo "[4/5] Setting up API key helper..."

cat > "$CLAUDE_DIR/anthropic_key_helper.sh" << 'HELPER'
#!/bin/bash
echo "${ANTHROPIC_API_KEY}"
HELPER
chmod +x "$CLAUDE_DIR/anthropic_key_helper.sh"

echo "[5/5] Configuring claude.json..."

if [ -n "$ANTHROPIC_API_KEY" ]; then
    KEY_SUFFIX="${ANTHROPIC_API_KEY: -20}"
    cat > "$HOME/.claude.json" << EOF
{"customApiKeyResponses":{"approved":["$KEY_SUFFIX"],"rejected":[]},"shiftEnterKeyBindingInstalled":true,"theme":"dark","hasCompletedOnboarding":true}
EOF
else
    cat > "$HOME/.claude.json" << 'EOF'
{"shiftEnterKeyBindingInstalled":true,"theme":"dark","hasCompletedOnboarding":true}
EOF
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    COMPLETE 🚀                                    ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Commands: /autonomous /ship /fix /resume /state /skills"
echo "Let's make money, TJ. 💰"
