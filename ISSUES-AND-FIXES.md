# TYRONE AI - Known Issues & Improvements
# Updated: 2026-01-20

## Issues TJ Identified

### 1. Session Loss on Disconnect ✅ FIXED
**Problem:** If connection is lost to terminal, everything from that session is gone.
**Solution:** 
- `.claude-session-state.json` in every project
- `/state` command saves before disconnect
- `/resume` command continues after reconnect
- Auto-save hook can run in background

### 2. Inconsistent Autonomous Behavior ✅ FIXED
**Problem:** "Autonomous" means different things in each new project.
**Solution:**
- Global `~/.claude/CLAUDE.md` with 12 Laws of Autonomous Execution
- Every project inherits this automatically
- `/autonomous` slash command to reinforce
- `/skills` command to reload skills

### 3. Claude Being Lazy / Giving Tasks to User ✅ FIXED
**Problem:** Claude gives TJ tasks to do instead of doing them itself.
**Solution:**
- CLAUDE.md explicitly states: "You are NOT an assistant awaiting approval"
- Anti-placeholder directive in the 12 Laws
- Pre-approved operations list - just do it

### 4. YouTube Influencers Know More Than Paying Customers
**Problem:** Feature announcements reach influencers before $100/month customers.
**Status:** Outside our control - this is Anthropic's communication issue.
**Workaround:** 
- We can set up a web scraper/RSS for Anthropic announcements
- Auto-alert when new features drop

### 5. Complex Solutions Before Simple Ones ✅ FIXED
**Problem:** 17-step solution when "Ctrl+C" would work.
**Solution:**
- Law 7: Simplest Solution First
- "If one command works, say one command. NOT 17 steps."

### 6. Security Lectures to PhD Researcher ✅ FIXED
**Problem:** Claude freaks out about API keys when stakes are zero (YubiKey, security officer monitoring).
**Solution:**
- CLAUDE.md: "TJ is a PhD researcher. Do not explain obvious things. Do not lecture about security."
- Law 8: "Keys provided = keys authorized. NO SECURITY LECTURES."

### 7. Skills Not Respected ✅ FIXED
**Problem:** Claude Code agent refused to comply with skill files.
**Solution:**
- Critical Startup Protocol in CLAUDE.md: Read skills FIRST
- `/skills` command to force reload
- Env var: `CLAUDE_SKILLS_FIRST=true`

### 8. Template Being Used as Active Project ✅ FIXED
**Problem:** TYRONE AI template occupied by current build, forces repetition.
**Solution:**
- Separate template system: `~/.tyrone-ai-template/` (NEVER modified)
- Project launcher: `tyrone <project-name>` creates fresh project
- All projects go to `~/projects/<name>/`
- Template stays clean forever

## Future Improvements

### Auto-Backup Session State
- Cron job or background process
- Save every 5 minutes
- Sync to cloud (GitHub Gist, S3, etc.)

### Project Dashboard
- Web UI to view all projects
- Session states at a glance
- Quick resume buttons

### Claude Announcement Tracker
- RSS feed from Anthropic
- Slack/Discord notifications
- Changelog diff highlighting

### Skills Marketplace
- Share skills with community
- Import others' skills easily
- Version control for skills

## Quick Reference

```bash
# New project
tyrone my-project

# Enter project
cd ~/projects/my-project
claude

# If Claude forgets
/autonomous
/skills

# Before disconnect
/state

# After reconnect
/resume

# List projects
projects
```
