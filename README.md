# Claude Code Kickstart

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/UsernameTron/Claude-Code-Kickstart/actions/workflows/ci.yml/badge.svg)](https://github.com/UsernameTron/Claude-Code-Kickstart/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/UsernameTron/Claude-Code-Kickstart)](https://github.com/UsernameTron/Claude-Code-Kickstart/releases/latest)

**The governance framework for vibecoders** — describe what you want, the system handles engineering discipline.

---

## The Problem

AI-assisted development lets you build fast, but it's easy to skip the engineering discipline:

- No tests written (or tests that don't actually test anything)
- Secrets accidentally committed
- Commits directly to main
- No documentation, no handoff notes
- No code review, no security scanning
- Context lost between sessions

Whether you're a beginner who doesn't know the conventions or an experienced dev moving too fast to follow them — the result is the same: fragile code that works today and breaks tomorrow.

## The Solution

Claude Code Kickstart installs a complete governance framework that **automatically enforces** what you'd otherwise forget:

- **10 hooks** catch mistakes before they happen (secret scanning, branch protection, doc enforcement)
- **12 slash commands** for a structured workflow (`/prime` → `/plan` → `/build` → `/wrap`)
- **2 custom plugin engines** (MCP Ecosystem for agent lifecycle + Code Factory for extension generation)
- **13 official plugins** pre-configured and ready
- **45 skills** for everything from TDD enforcement to CI/CD generation
- **16 specialist agents** across both engines
- **6 reference documents** loaded on demand
- **5 test suites** with 146 assertions validating install, scaffold, health check, plugins, and integration
- **Project templates** so every new project starts with the right structure

One install. Zero discipline required from you.

---

## Quick Start

```bash
git clone https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart.git
cd claude-code-kickstart
./install.sh
```

Then in any project:

```
cd your-project
claude                    # SessionStart hook scans project
/prime                    # Boot session
/plan Build feature X     # Plan it
/build                    # Build it (agents take over)
/commit-push-pr           # Ship it
/wrap                     # Close session
```

Five commands. That's the daily workflow.

---

## What Gets Installed

The installer backs up your existing config, then:

1. Installs the global `CLAUDE.md` governance framework (~620 lines of rules, standards, and lifecycle)
2. Merges 10 hooks into your `settings.json` (won't overwrite existing hooks)
3. Merges 26 permission rules (deduplicates against existing)
4. Sets `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` for parallel agent execution
5. Copies 6 context reference files to `~/.claude/context/`
6. Configures autocompact at 50% context usage
7. Registers the Kickstart plugin marketplace
8. Installs 13 official plugins + 2 custom engines
9. Runs a health check to verify everything

---

## What's Included

### Hooks (Automatic Enforcement)

| Hook | Event | What It Does |
|------|-------|-------------|
| Project Scanner | SessionStart | Scans for git, CLAUDE.md, tests, agents — triggers bootstrap if missing |
| Branch Protector | PreToolUse:Bash | Blocks commits to main/master — requires feature branches |
| File Guard | PreToolUse:Bash | Blocks staging of .env, __pycache__, state/, context/, node_modules/ |
| Doc Enforcer | PreToolUse:Bash | Blocks commits if CLAUDE.md, README.md, or DEVOPS-HANDOFF.md missing |
| Secret Scanner | PreToolUse:Bash | Blocks commits containing API keys, tokens, or credentials |
| Nested Repo Detector | PreToolUse:Bash | Blocks git add when nested .git directories found |
| Pre-Push Safety | PreToolUse:Bash | Blocks push when uncommitted files exist |
| File Type Advisor | PostToolUse:Write/Edit | Context injection for test files, skills, Python files |
| Clean Tree Check | Stop | Blocks session close with uncommitted changes |
| State Preserver | PreCompact | Preserves task state references before context compaction |

### Slash Commands (12)

| Command | Purpose |
|---------|---------|
| `/prime` | Boot session — load context, lessons, agents, git state |
| `/plan` | Create implementation plan scaled to complexity |
| `/build` | Execute plan with Agent Teams (parallel TDD pipeline) |
| `/status` | Dashboard — tasks, git state, agents, work progress |
| `/wrap` | Close session — log work, record decisions, handoff notes |
| `/agents` | List deployed specialist agents |
| `/agent-setup` | Initial agent deployment for project |
| `/agent-status` | Agent health check |
| `/agent-diagnose` | Diagnose agent issues |
| `/agent-add` | Add specialist agent |
| `/agent-remove` | Remove agent |
| `/agent-reset` | Reset agent ecosystem |

### Plugin Engines

| Engine | Skills | Agents | Purpose |
|--------|--------|--------|---------|
| MCP Ecosystem | 7 | 6 | Session commands, agent lifecycle, workspace governance |
| Code Factory | 38 | 10 | Extension generation, reference library, dev team factory |

### Official Plugins (13)

| Plugin | Phase | Role |
|--------|-------|------|
| claude-code-setup | Bootstrap | Codebase analysis, automation recommendations |
| claude-md-management | Bootstrap | CLAUDE.md audit, scoring, session learning capture |
| hookify | Bootstrap | Project-specific hook rule authoring |
| security-guidance | Bootstrap | Passive security warnings on file edits |
| superpowers | Planning/Build | Brainstorming, TDD plans, parallel subagent dispatch |
| pyright-lsp | Build | Python type checking |
| frontend-design | Build | Frontend UI/UX guidance |
| code-review | Quality | Multi-agent PR review with confidence scoring |
| pr-review-toolkit | Quality | 6 specialized review agents |
| commit-commands | Ship | `/commit`, `/commit-push-pr`, `/clean-gone` |
| agent-sdk-dev | Utility | Claude Agent SDK reference |
| explanatory-output-style | Utility | Educational insights on implementation choices |
| ralph-loop | Utility | Continuous self-referential development loops |

### Community Plugins (Optional)

| Plugin | Purpose |
|--------|---------|
| agent-teams | Phase 2-3 engine: 5+N agent TDD pipeline |
| eval-harness | Test evaluation framework |
| verification-loop | Continuous verification |

---

## How Agent Systems Work

Three systems compose together — they're layers, not alternatives:

1. **MCP Ecosystem** sets up project agent infrastructure (once per project)
2. **Agent Teams** runs the development pipeline with parallel feature chains (per build)
3. **Subagents** handle individual tasks within each system (reviews, research, debugging)

For 2+ features: Agent Teams spawns a full 5-agent team plus one Feature Agent per component. Each follows a strict 10-step TDD pipeline: Spec → Spec Review → Write Tests → RED Verify → Implement → GREEN Verify → Validate → Code Review → Security Scan → Branch + PR.

See [docs/architecture.md](docs/architecture.md) for the full technical overview.

---

## New Project Setup

```bash
# Create and scaffold a new project
mkdir ~/my-project && cd ~/my-project
bash ~/path/to/claude-code-kickstart/scripts/scaffold-project.sh
claude
```

This creates: CLAUDE.md, README.md, .gitignore, tasks/lessons.md, docs/DEVOPS-HANDOFF.md, and the standard directory structure.

---

## Customization

- **Coverage thresholds:** Edit `~/.claude/CLAUDE.md` (default: 90% overall, 80% per module, 95% security-critical)
- **Add hooks:** Edit `~/.claude/settings.json` hooks section
- **Add permissions:** Append to `permissions.allow` array
- **Add skills:** Create `.claude/skills/name/SKILL.md`
- **Add agents:** Create `.claude/agents/name.md`
- **Adjust autocompact:** Change `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` in `~/.zshrc`

See [docs/customization.md](docs/customization.md) for details.

---

## Documentation

| Doc | Purpose |
|-----|---------|
| [docs/getting-started.md](docs/getting-started.md) | Step-by-step first use tutorial |
| [docs/troubleshooting.md](docs/troubleshooting.md) | Every failure mode + fixes |
| [docs/customization.md](docs/customization.md) | How to adjust thresholds, hooks, etc. |
| [docs/architecture.md](docs/architecture.md) | How the three agent systems compose |
| [docs/DEVOPS-HANDOFF.md](docs/DEVOPS-HANDOFF.md) | DevOps handoff: install, config, security, tech debt |
| [docs/user-guide.md](docs/user-guide.md) | Beginner's guide: all 45 commands, scenarios, decision trees |
| [docs/command-reference.md](docs/command-reference.md) | Quick-reference table of all slash commands |

---

## Credits

Built by C. Pete Connor.

Published: *Crushin' Claude* — a guide to AI productivity.


---

## License

MIT — see [LICENSE](LICENSE).
