# Customization Guide

## Coverage Thresholds

Edit the `Code Standards > Coverage Standards` section in `~/.claude/CLAUDE.md`:

```markdown
- Overall project coverage must be >=90% before any handoff
- No individual module may fall below 80% coverage
- Security-critical modules must be >=95%
```

Adjust these percentages to match your team's standards.

---

## Hooks

### Add a Custom Hook

Edit `~/.claude/settings.json` under the `hooks` section:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "INPUT=$(cat); echo \"$INPUT\" | your-validator.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Rules:**
- All hooks must be `"type": "command"` (except Stop/SubagentStop which support `"type": "prompt"`)
- Use `INPUT=$(cat)` to read tool input from stdin
- Exit code 0 = allow, exit code 2 = block
- Block output goes to stderr and is shown to Claude

### Disable a Hook

Remove the entry from `~/.claude/settings.json`. JSON does not support comments, so the entry must be deleted entirely.

### Hook Events

| Event | When | Use For |
|-------|------|---------|
| SessionStart | Session begins | Project scanning, context loading |
| PreToolUse | Before tool runs | Validation, blocking dangerous commands |
| PostToolUse | After tool completes | Linting, context injection |
| Stop | Agent finishes | Completeness checks |
| PreCompact | Before compaction | Task state preservation |

---

## Permissions

### Add Permission Rules

Append to `permissions.allow` in `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(your-command *)",
      "Read(your-file-pattern)"
    ]
  }
}
```

### Pattern Syntax

- `Bash(npm test)` -- Exact command
- `Bash(npm run:*)` -- Prefix match (anything starting with "npm run")
- `Read(./.env)` -- Specific file
- `Read(./secrets/**)` -- Glob pattern

---

## Skills

### Add Project-Specific Skills

Create `.claude/skills/your-skill/SKILL.md`:

```markdown
---
name: your-skill
description: What it does and when to use it.
---

## Instructions
[Your skill content]
```

### Add Personal Skills

Create `~/.claude/skills/your-skill/SKILL.md` for skills available across all projects.

---

## Agent Configuration

### Add Project Agents

Create `.claude/agents/your-agent.md`:

```markdown
---
name: your-agent
description: When to invoke this agent.
tools: Read, Write, Edit, Bash
model: sonnet
---

Your agent's system prompt here.
```

### Model Selection

- `opus` -- Complex reasoning, architectural decisions
- `sonnet` -- General coding, reviews
- `haiku` -- Simple/mechanical tasks (test running, git operations)

---

## Autocompact Threshold

Adjust when context compaction triggers:

```bash
# In ~/.zshrc or ~/.bashrc
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50  # Default installed value
```

Lower = more aggressive compaction. Higher = larger context before compacting.

---

## Documentation Requirements

Edit `Code Standards > Documentation Standards` in `~/.claude/CLAUDE.md` to change which files are required:

```markdown
Every project must have three living documents:
1. CLAUDE.md
2. README.md
3. docs/DEVOPS-HANDOFF.md
```

The PreToolUse hook in `settings.json` enforces this on commit. Modify the hook command to change the required file list.

---

## Plugin Marketplaces

### Register Additional Marketplaces

Add to `extraKnownMarketplaces` in `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "your-marketplace": {
      "source": {
        "source": "github",
        "repo": "org/repo-name"
      }
    }
  }
}
```

### Enable/Disable Plugins

```json
{
  "enabledPlugins": {
    "plugin-name@marketplace": true
  }
}
```
