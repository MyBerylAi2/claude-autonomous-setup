#!/bin/bash
#############################################################################
# TYRONE AI - Project Launcher
# Keeps your template CLEAN. Spins up new projects with EVERYTHING pre-loaded.
# 
# Usage: ./launch-project.sh <project-name>
# Example: ./launch-project.sh my-new-app
#############################################################################

set -e

# Config
TEMPLATE_DIR="$HOME/.tyrone-ai-template"
PROJECTS_DIR="$HOME/projects"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check for project name
if [ -z "$1" ]; then
    echo "Usage: tyrone <project-name>"
    echo "Example: tyrone my-new-app"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              TYRONE AI - Launching: $PROJECT_NAME${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════╝${NC}"

# Create project directory
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Project '$PROJECT_NAME' already exists at $PROJECT_DIR${NC}"
    echo "Opening existing project..."
else
    echo "[1/5] Creating project directory..."
    mkdir -p "$PROJECT_DIR"
    
    echo "[2/5] Copying template structure..."
    
    # Create .claude directory with full config
    mkdir -p "$PROJECT_DIR/.claude/commands"
    
    # Project CLAUDE.md - inherits global + adds project-specific
    cat > "$PROJECT_DIR/CLAUDE.md" << CLAUDEMD
# Project: $PROJECT_NAME
# Created: $TIMESTAMP
# Template: TYRONE AI

## INHERIT GLOBAL PROTOCOL
All rules from ~/.claude/CLAUDE.md apply. This project operates under FULL AUTONOMOUS AUTHORITY.

## Project Context
<!-- TJ: Fill this in once at project start, then Claude handles everything -->

### What We're Building


### Tech Stack


### Key Constraints


### Success Criteria


## Project-Specific Notes


## Session Log
<!-- Claude: Add major decisions/milestones here -->
- $TIMESTAMP: Project initialized from TYRONE AI template
CLAUDEMD

    # Project settings (inherits from global, can override)
    cat > "$PROJECT_DIR/.claude/settings.json" << 'SETTINGS'
{
  "permissions": {
    "allow": ["Read", "Write", "Edit", "Bash(*)", "Glob", "Grep", "Search", "mcp__*"],
    "deny": []
  }
}
SETTINGS

    # Session state file
    cat > "$PROJECT_DIR/.claude-session-state.json" << SESSIONSTATE
{
  "version": "1.0.0",
  "session_id": "${RANDOM}${RANDOM}",
  "created_at": "$TIMESTAMP",
  "last_updated": "$TIMESTAMP",
  "project": {
    "name": "$PROJECT_NAME",
    "root_path": "$PROJECT_DIR",
    "template": "TYRONE AI",
    "type": null,
    "tech_stack": []
  },
  "execution_state": {
    "current_task": "Project initialization - awaiting brief from TJ",
    "completed_tasks": ["Template setup"],
    "pending_tasks": [],
    "blocked_tasks": []
  },
  "decisions_made": [],
  "files_modified": ["CLAUDE.md", ".claude/settings.json"],
  "dependencies_installed": [],
  "notes": ["Fresh project from TYRONE AI template"],
  "resume_instructions": "Fill in CLAUDE.md project context, then execute."
}
SESSIONSTATE

    # Git init
    echo "[3/5] Initializing git..."
    cd "$PROJECT_DIR"
    git init -q
    
    cat > .gitignore << 'GITIGNORE'
# Claude
.claude-session-state.json
.claude/settings.local.json

# Environment
.env
.env.*
*.local

# Dependencies
node_modules/
venv/
.venv/
__pycache__/
*.pyc

# Build
dist/
build/
*.egg-info/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
GITIGNORE

    git add -A
    git commit -q -m "Initial commit from TYRONE AI template"
    
    echo "[4/5] Project structure created..."
    
    echo "[5/5] Ready to launch!"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    PROJECT READY 🚀                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Location: ${CYAN}$PROJECT_DIR${NC}"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  claude"
echo ""
echo "First thing Claude will do: Read your skills + CLAUDE.md, then await your brief."
echo ""

# Optionally cd into project
cd "$PROJECT_DIR"
echo -e "${YELLOW}You're now in: $(pwd)${NC}"
