# Architecture

## Overview

Claude Code Kickstart is a governance framework that combines three agent systems, automatic hooks, and configuration templates to enforce engineering discipline for AI-assisted development.

```
+-------------------------------------------------------------+
|                     Claude Code Session                      |
|                                                              |
|  +----------+  +--------------+  +------------------------+ |
|  |  Hooks   |  | Global       |  |  Plugins               | |
|  | (10)     |  | CLAUDE.md    |  |  (20)                  | |
|  |          |  | (governance) |  |                        | |
|  | Pre/Post |  |              |  |  MCP Ecosystem         | |
|  | Session  |  | Lifecycle    |  |  Code Factory          | |
|  | Stop     |  | Standards    |  |  13 Official           | |
|  | Compact  |  | Rules        |  |  3 Community           | |
|  +----------+  +--------------+  +------------------------+ |
+-------------------------------------------------------------+
```

---

## Three Agent Systems

### 1. Agent Teams (Primary Build Engine)

The main development pipeline. Spawns 5 permanent agents plus one Feature Agent per component:

| Agent | Role | Model |
|-------|------|-------|
| Team Lead | Orchestrates, spawns Feature Agents, monitors | Opus |
| Quality Agent | TDD enforcement, coverage verification | Haiku |
| Code Review Agent | Multi-engine code review | Sonnet |
| Security Agent | OWASP scanning, secrets detection | Haiku |
| Merger Agent | Branch + PR creation | Haiku |
| Feature Agent (x N) | Implements features following 10-step pipeline | Sonnet/Opus |

**When used:** 2+ independent features or components to build.

### 2. MCP Ecosystem (Agent Lifecycle)

Manages persistent specialist agents that remember context across sessions:

```
Layer 0: project-guide (invisible router)
    |
Layer 1: subagent-concierge (setup) / subagent-companion (management)
    |
Layer 2: architect -> scaffolder + memory-seeder (parallel) -> validator
          auditor (diagnostics)
```

**When used:** Setting up project agent infrastructure, managing specialists.

### 3. Subagents (Individual Task Delegation)

Single-purpose Claude instances for focused work:
- **Subagent-driven-dev:** Single feature with 3+ tasks, two-stage review
- **Parallel review:** 5-6 specialized reviewers running simultaneously
- **Research:** Multiple angles investigated in parallel

**When used:** Code review, debugging, research, single-feature work.

---

## Hook Lifecycle

```
Session Start
    |
    v
SessionStart hook --> Scans project (git, CLAUDE.md, tests, agents)
    |
    v
User works...
    |
    +-- PreToolUse:Bash --> Branch safety (blocks main/master commits)
    +-- PreToolUse:Bash --> Staged file validation (blocks .env, etc.)
    +-- PreToolUse:Bash --> Required docs check (CLAUDE.md, README, HANDOFF)
    +-- PreToolUse:Bash --> Secrets scanning (API keys, tokens)
    +-- PreToolUse:Bash --> Nested repo detection
    +-- PreToolUse:Bash --> Pre-push safety (uncommitted files)
    |
    +-- PostToolUse:Write|Edit --> File type detection, test reminders
    |
    +-- PreCompact --> Task state preservation
    |
    +-- Stop --> Clean tree verification
```

All hooks use `"type": "command"` with `INPUT=$(cat)` for stdin. Exit code 2 blocks the operation.

---

## Plugin Dependency Chain

```
Phase 0 (Bootstrap):
  claude-code-setup -> claude-md-management -> hookify -> security-guidance
  MCP Ecosystem: project-guide -> subagent-concierge

Phase 1 (Planning):
  superpowers: brainstorming -> writing-plans

Phase 2 (Building):
  agent-teams (primary engine)
  superpowers: subagent-driven-development
  pyright-lsp, frontend-design (passive)

Phase 3 (Quality):
  Built into agent-teams pipeline (Steps 4, 6, 7, 8, 9)
  code-review, pr-review-toolkit (supplemental)

Phase 4 (Ship):
  commit-commands: /commit, /commit-push-pr, /clean-gone

Phase 5 (Close):
  claude-md-management: /revise-claude-md
  MCP Ecosystem: /wrap
```

---

## Settings Structure

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": [...]
  },
  "hooks": {
    "SessionStart": [],
    "PreToolUse": [],
    "PostToolUse": [],
    "Stop": [],
    "PreCompact": []
  },
  "enabledPlugins": {},
  "extraKnownMarketplaces": {}
}
```

---

## Scope: Global vs Project

| Scope | Location | What It Controls |
|-------|----------|------------------|
| Global | `~/.claude/CLAUDE.md` | Governance framework, lifecycle, agent rules |
| Global | `~/.claude/settings.json` | Hooks, permissions, env vars, plugins |
| Global | `~/.claude/context/*.md` | Reference documentation (6 files) |
| Project | `./CLAUDE.md` | Project-specific architecture, conventions |
| Project | `.claude/settings.json` | Team project settings (committed) |
| Project | `.claude/settings.local.json` | Personal project settings |
| Project | `.claude/agents/*.md` | Project-specific agents |
| Project | `.claude/skills/*/SKILL.md` | Project-specific skills |

Project settings extend and can override global settings. Permission rules merge (most restrictive wins for deny, union for allow).

---

## File Structure Convention

```
project/
├── CLAUDE.md                # Project governance
├── README.md                # Public-facing docs
├── _project_specs/          # Feature specifications
│   └── features/            # One .md per feature
├── tasks/                   # Task tracking
│   ├── todo.md              # Current plan
│   └── lessons.md           # Rules from corrections
├── context/                 # Operator identity (gitignored)
├── state/                   # Session audit trail (gitignored)
├── .claude/
│   ├── agents/              # Agent definitions
│   └── skills/              # Project skills
├── plans/                   # Implementation plans (gitignored)
├── outputs/                 # Work products (gitignored)
├── decisions/               # Architecture decision records
└── docs/
    └── DEVOPS-HANDOFF.md    # DevOps delivery docs
```
