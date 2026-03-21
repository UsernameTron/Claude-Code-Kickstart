# DevOps Handoff — Claude Code Kickstart

**Last Updated:** 2026-03-21
**Version:** 1.0.0
**Status:** Production-Ready

---

## Project Summary

Claude Code Kickstart is an open-source governance framework that installs hooks, plugins, templates, agent definitions, and documentation into a Claude Code environment. It is **not** a running application — it is a distribution of configuration files and scripts that enforce engineering discipline automatically.

The framework packages two custom plugin engines (MCP Ecosystem for agent lifecycle + Code Factory for extension generation), 10 enforcement hooks, 13 official plugins, 45+ skills, 16 specialist agents, and project scaffolding templates.

---

## Current State

| Attribute | Value |
|-----------|-------|
| Version | 1.0.0 |
| Branch | `main` |
| Files | ~198 |
| Test suite | None (configuration distribution — validated via `health-check.sh`) |
| Known issues | None |
| CI/CD | Not applicable |

---

## Environment Requirements

| Requirement | Minimum Version | Notes |
|-------------|-----------------|-------|
| Claude Code CLI | Latest | Must be installed and in `PATH` as `claude` |
| Python 3 | 3.10+ | Used by `install.sh` for JSON merging (settings, hooks, permissions) |
| Git | Any recent | Required for repo operations and branch protection hooks |
| Bash | 4.0+ | Scripts use arrays and parameter expansion |
| macOS or Linux | Any | Scripts are portable; `sed -i` adapts to Darwin vs GNU |
| `gh` CLI (optional) | Any | Only needed if using `/commit-push-pr` for PR creation |

No runtime services, databases, containers, or cloud accounts required.

---

## How to Install

### 1. Clone and run the installer

```bash
git clone https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart.git
cd claude-code-kickstart
./install.sh
```

The installer will:
1. Verify prerequisites (`claude`, `python3`, `git`)
2. Back up existing `~/.claude/CLAUDE.md` and `~/.claude/settings.json`
3. Prompt for name, GitHub username, email, and org (used to fill placeholders)
4. Install the global `CLAUDE.md` governance framework
5. Merge 10 hooks into `settings.json` (additive — won't overwrite existing)
6. Merge 26 permission rules (deduplicates)
7. Set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
8. Copy 6 context reference files to `~/.claude/context/`
9. Configure autocompact at 50% context usage in shell RC
10. Register the Kickstart plugin marketplace
11. Install 13 official plugins + 2 custom engines via `scripts/install-plugins.sh`
12. Run `scripts/health-check.sh` to verify

### 2. Verify installation

```bash
bash scripts/health-check.sh
```

Checks: CLI presence, settings structure, hooks, permissions, env vars, context files.

### 3. Scaffold a new project

```bash
mkdir ~/my-project && cd ~/my-project
bash ~/path/to/claude-code-kickstart/scripts/scaffold-project.sh
```

Creates: `CLAUDE.md`, `README.md`, `.gitignore`, `tasks/lessons.md`, `docs/DEVOPS-HANDOFF.md`, and the standard directory structure (`_project_specs/`, `tasks/`, `context/`, `state/`, `.claude/agents/`, `.claude/skills/`, `plans/`, `outputs/`, `decisions/`, `docs/`).

### 4. Daily workflow

```
cd your-project
claude            # SessionStart hook auto-scans
/prime            # Boot session
/plan <request>   # Plan work
/build            # Execute (agents handle implementation)
/commit-push-pr   # Ship
/wrap             # Close session
```

---

## Configuration Reference

### Files installed by the framework

| File | Location | Purpose |
|------|----------|---------|
| Global CLAUDE.md | `~/.claude/CLAUDE.md` | ~620-line governance framework — lifecycle, agent systems, standards |
| settings.json | `~/.claude/settings.json` | Hooks, permissions, env vars, plugin config |
| CLI reference | `~/.claude/context/cli-reference.md` | Claude Code CLI commands and flags |
| Skill creation guide | `~/.claude/context/skill-creation-guide.md` | How to write SKILL.md files |
| MCP setup guide | `~/.claude/context/mcp-setup-guide.md` | MCP server configuration |
| Subagent guide | `~/.claude/context/subagent-guide.md` | Agent creation reference |
| Hooks guide | `~/.claude/context/hooks-guide.md` | Hook events and configuration |
| Settings reference | `~/.claude/context/settings-reference.md` | Settings.json schema reference |

### Key environment variables

| Variable | Set By | Value | Purpose |
|----------|--------|-------|---------|
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | settings.json `env` | `1` | Enables parallel agent team execution |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Shell RC (~/.zshrc) | `50` | Auto-compact context at 50% usage |

### Hooks (10)

| Hook | Event | What It Enforces |
|------|-------|-----------------|
| Project Scanner | SessionStart | Detects missing git, CLAUDE.md, tests, agents |
| Branch Protector | PreToolUse:Bash | Blocks commits to main/master |
| File Guard | PreToolUse:Bash | Blocks staging of .env, __pycache__, state/, context/ |
| Doc Enforcer | PreToolUse:Bash | Blocks commits if required docs missing |
| Secret Scanner | PreToolUse:Bash | Blocks commits containing API keys or tokens |
| Nested Repo Detector | PreToolUse:Bash | Blocks git add with nested .git directories |
| Pre-Push Safety | PreToolUse:Bash | Blocks push with uncommitted files |
| File Type Advisor | PostToolUse:Write/Edit | Context injection for specific file types |
| Clean Tree Check | Stop | Blocks session close with uncommitted changes |
| State Preserver | PreCompact | Preserves task state before context compaction |

---

## Security Notes

- **No secrets in repo.** All personal data sanitized with placeholders (`[YOUR NAME]`, `[YOUR EMAIL]`, etc.)
- **Backup before overwrite.** The installer timestamps and backs up existing `CLAUDE.md` and `settings.json` before touching them.
- **Secret scanning hook.** Blocks `git commit` when staged files contain patterns matching API keys, tokens, or credentials.
- **File guard hook.** Prevents accidental staging of `.env`, `__pycache__/`, `state/`, `context/`, and `node_modules/`.
- **Branch protection.** Commits directly to `main`/`master` are blocked — feature branches required.
- **No network calls.** The installer runs entirely locally. Plugin installation uses `claude plugin install` which may fetch from registries.
- **Permissions are additive.** The installer merges new permission rules without removing existing ones.

---

## Deployment Maturity

| Aspect | Status | Notes |
|--------|--------|-------|
| Installation script | Complete | Portable macOS + Linux, backs up existing config |
| Health check validation | Complete | 11 checks covering all installed components |
| Project scaffolding | Complete | Creates full directory structure + starter files |
| Documentation | Complete | 4 user docs + 6 context references |
| Plugin engines | Complete | MCP Ecosystem (7 skills, 6 agents) + Code Factory (38 skills, 10 agents) |
| Hook enforcement | Complete | 10 hooks covering session lifecycle, commits, security |
| CI/CD pipeline | Not applicable | Distribution repo, not an application |
| Automated tests | Not applicable | Validated via `health-check.sh` post-install |
| Versioning | Manual | Version tracked in CLAUDE.md, README.md, and this file |

---

## Known Tech Debt

1. **File counts are manually tracked** across CLAUDE.md, README.md, and DEVOPS-HANDOFF.md. No automation keeps them in sync — they drift when files are added.
2. **Placeholder replacement is sed-based.** The installer uses `sed -i` with OS detection (Darwin vs GNU). Edge cases with special characters in user input are not escaped.
3. **Plugin installation is sequential.** `install-plugins.sh` installs plugins one at a time. Parallel installation could reduce setup time.
4. **No uninstall script.** Reverting requires manually restoring backups or re-editing settings.json.
5. **Health check is post-install only.** No pre-flight check validates the environment before installation begins (beyond `which` checks for 3 binaries).
6. **Version is not programmatically sourced.** The version string `1.0.0` appears in multiple files and must be updated manually.

---

## Contact

- **Author:** [YOUR NAME]
- **Email:** [YOUR EMAIL]
- **Repository:** `https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart`
