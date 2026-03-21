# Troubleshooting

## Common Issues

| Error | Cause | Fix |
|-------|-------|-----|
| `SessionStart:startup hook error` | SessionStart only supports `command` type, not `prompt` | Ensure all SessionStart hooks use `"type": "command"` |
| `Stop hook error: JSON validation failed` | Stop hook must return `{"decision": "approve/block", "reason": "..."}` | Use decision/reason JSON schema with exit code 2 for block |
| `PostToolUse:Write hook error` | PostToolUse prompt hooks must return `{"additionalContext": "..."}` | Convert to `command` type |
| PreToolUse hooks not firing | Hook reads `$CLAUDE_TOOL_INPUT` which is not populated for command hooks | Use `INPUT=$(cat)` to read from stdin instead |
| Hooks blocking compound commands | `cd /path && git commit` matches `git commit` pattern | Split into separate commands or accept occasional prompts |
| Permission prompts on every command | No `permissions.allow` rules configured | Run install.sh to merge permission rules, or add manually to settings.json |
| Auto-compact firing too late | Default threshold is 95% | Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50` (install.sh does this automatically) |

---

## Installation Issues

### "claude: command not found"
Claude Code is not installed or not in your PATH.
```bash
# Check installation
which claude
# If missing, install from https://docs.anthropic.com/en/docs/claude-code
```

### "python3: command not found"
Python 3 is required for JSON merging during installation.
```bash
# macOS
brew install python3
# Linux
sudo apt install python3
```

### "Permission denied" on install.sh
```bash
chmod +x install.sh
./install.sh
```

### Hooks not taking effect after install
Restart Claude Code. Settings changes require a new session.

### Backup files everywhere
The installer creates timestamped backups before overwriting. These are safe to delete:
```bash
ls ~/.claude/*.backup.*
# Remove old backups if desired
```

---

## Plugin Issues

### "Could not install plugin"
Check your internet connection and that the marketplace is accessible:
```bash
claude plugin list
```

### Plugin not showing up
Ensure the plugin is enabled in settings.json:
```json
{
  "enabledPlugins": {
    "plugin-name@marketplace": true
  }
}
```

### MCP Ecosystem or Code Factory not found
Verify the kickstart marketplace is registered:
```bash
python3 -c "import json; d=json.load(open('$HOME/.claude/settings.json')); print(d.get('extraKnownMarketplaces', {}).get('kickstart-local', 'NOT FOUND'))"
```

---

## Hook Issues

### "Blocked: attempting to stage private/generated files"
You're trying to `git add` files that should be in .gitignore:
- `state/`, `context/`, `.DS_Store`, `__pycache__/`, `.env`, `node_modules/`, `outputs/`

Fix: Add them to .gitignore, then `git rm --cached` if already tracked.

### "Do not commit directly to main/master"
Create a feature branch:
```bash
git checkout -b feat/your-feature
```

### "Missing required docs"
Create the required files before committing:
- `CLAUDE.md` -- Use `/init` or copy from templates
- `README.md` -- Create project README
- `docs/DEVOPS-HANDOFF.md` -- Copy from templates

### Stop hook blocks session close
You have uncommitted changes:
```bash
git status
git add . && git commit -m "your message"
# or
git stash
```

---

## Agent Issues

### Agent Teams not spawning
Verify the env var is set:
```bash
grep CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS ~/.claude/settings.json
```

### Subagents not found
Check agent definitions exist:
```bash
ls .claude/agents/
ls ~/.claude/agents/
```

### Agent quality gate blocking
Review the agent's feedback. Quality, Security, and Code Review agents block on Critical/High issues. Fix the issues and the pipeline continues automatically.

---

## Getting Help

- Check [customization.md](customization.md) for configuration options
- Check [architecture.md](architecture.md) for how the system works
- File issues at: https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart/issues
