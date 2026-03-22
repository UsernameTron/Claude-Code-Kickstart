# Claude Code Command Reference — Complete Workflow Guide

## Author: [YOUR NAME]
## Scope: All 20 plugins, all slash commands, lifecycle order, when and why

---

## The 5-Command Daily Lifecycle

This is the core loop you use for every project session:

```
/prime → /plan → /build → /commit-push-pr → /wrap
```

| Step | Command | Plugin | What It Does | When to Use |
|------|---------|--------|--------------|-------------|
| 1 | `/prime` | claude-mcp-ecosystem | Boots the session. Loads context (lessons, agents, git state, last session). Creates tasks/ if missing. Reports what's present and what's missing. | **Always first.** Every session starts here. |
| 2 | `/plan` | claude-mcp-ecosystem | Creates an implementation plan. Assesses complexity, determines if agent-teams or subagents are needed, waits for your approval before executing. | After `/prime`, when you have a task to work on. |
| 3 | `/build` | claude-mcp-ecosystem | Executes the plan. For 2+ features, deploys Agent Teams (parallel Feature Agents). For single features, uses subagent-driven-dev. Runs the full TDD pipeline. | After `/plan` is approved. |
| 4 | `/commit-push-pr` | commit-commands | Creates a feature branch, commits all changes, pushes to origin, creates a GitHub PR with a summary. | After `/build` completes and tests pass. |
| 5 | `/wrap` | claude-mcp-ecosystem | Closes the session. Logs work to session-log.md, updates decisions.md, verifies clean git state. Stop hook blocks if uncommitted files exist. | **Always last.** Every session ends here. |

---

## Phase 0 — New Project Bootstrap

Use these when starting a brand new project with no existing Claude Code infrastructure.

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/claude-automation-recommender` | claude-code-setup | Analyzes your codebase and recommends which Claude Code features to enable. | First time opening a project in Claude Code. |
| `/revise-claude-md` | claude-md-management | Creates or rewrites the project CLAUDE.md based on codebase analysis. | When CLAUDE.md is missing or stale. |
| `/claude-md-improver` | claude-md-management | Audits and scores an existing CLAUDE.md (0-100). | Quality check on your CLAUDE.md. |
| `/hookify` | hookify | Generates project-specific hook rules for quality enforcement. | Setting up hooks for a new project. |
| `/configure` | hookify | Interactive configuration for project hooks and rules. | Fine-tuning hook behavior. |

---

## Phase 1 — Planning & Complexity Assessment

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/plan` | claude-mcp-ecosystem | Creates a structured plan with complexity assessment. Determines agent allocation. | Before any multi-step work. |
| `/writing-plans` | superpowers | Advanced plan writing with structured thinking and risk assessment. | Complex architectural decisions where `/plan` needs more depth. |
| `/brainstorming` | superpowers | Structured brainstorming with divergent/convergent phases. | When you need creative options before committing to a plan. |

---

## Phase 2 — Building (Agent Teams & Subagents)

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/build` | claude-mcp-ecosystem | Deploys the full build pipeline. Uses Agent Teams for 2+ features, subagents for single features. | After `/plan` is approved. This is the main build command. |
| `/dispatching-parallel-agents` | superpowers | Manually dispatches parallel subagents for custom tasks. | When `/build` doesn't fit your workflow or you need custom parallel work. |
| `/subagent-driven-development` | superpowers | Single-feature development using one subagent per task with two-stage review. | Single features with 3+ subtasks. |
| `/test-driven-development` | superpowers | Enforces RED-GREEN-REFACTOR cycle. | When you want strict TDD discipline. |
| `/ralph-loop` | ralph-loop | Continuous development loop — keeps working until done. | Long-running autonomous tasks. |
| `/cancel-ralph` | ralph-loop | Stops a running ralph-loop. | When you need to interrupt. |

---

## Phase 2.5 — Extension & Agent Generation (Code Factory)

Use these when you need to CREATE new Claude Code extensions.

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/cc-factory` | claude-code-factory | Main entry point for extension generation from natural language. | Building a new skill, hook, agent, or plugin. |
| `/extension-guide` | claude-code-factory | Layer 0 router — classifies what you need and routes to the right generator. | Not sure which generator to use. |
| `/extension-concierge` | claude-code-factory | Non-technical entry point for extension creation. | Describe what you need without knowing terminology. |
| `/smart-scaffold` | claude-code-factory | Tier-based scaffolding for quick prototyping. | Quick extension prototyping. |
| `/agent-factory` | claude-code-factory | Generates agent definition files with YAML frontmatter. | Need new specialist agents. |
| `/dev-team-guide` | claude-code-factory | Router for dev team creation. | Building a team of agents for a domain. |
| `/dev-team-concierge` | claude-code-factory | Guided dev team setup for non-experts. | Building dev teams without knowing architecture. |
| `/dev-recipes` | claude-code-factory | Quick recipe patterns for common scenarios. | Pre-built patterns instead of designing from scratch. |
| `/scenario-library` | claude-code-factory | Common scenario patterns with pre-built solutions. | Browsing available patterns. |
| `/extension-fixer` | claude-code-factory | Fixes broken extensions (skills, agents, hooks). | Skill not triggering or agent has frontmatter errors. |
| `/extension-auditor` | claude-code-factory | Scans skill and agent directories for structural issues. | Periodic health check on extension ecosystem. |
| `/extension-installer` | claude-code-factory | Installs generated extensions to correct directories. | Deploy after generating an extension. |

---

## Phase 3 — Code Review & Quality

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/code-review` | code-review | Deploys 5 parallel review agents against the current diff. | After `/build`, before `/commit-push-pr`. |
| `/review-pr` | pr-review-toolkit | Reviews a specific GitHub PR with 6 specialized agents. | Reviewing PRs before merge. |
| `/requesting-code-review` | superpowers | Prepares code for review — writes a review request with context. | Submitting code for human review. |
| `/receiving-code-review` | superpowers | Processes feedback from a code review and applies fixes. | After receiving review comments. |
| `/verification-before-completion` | superpowers | Final verification gate — prevents claiming done without evidence. | Before marking any task complete. |
| `/systematic-debugging` | superpowers | Structured debugging: reproduce, isolate, diagnose, fix, verify. | When something is broken. |

---

## Phase 4 — Git & Shipping

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/commit` | commit-commands | Creates a conventional commit on the current branch. | Commit without pushing. |
| `/commit-push-pr` | commit-commands | Commits, pushes, and creates a PR in one step. | Standard shipping command. |
| `/clean-gone` | commit-commands | Deletes local branches whose remote tracking branch is gone. | After merging PRs on GitHub. |
| `/finishing-a-development-branch` | superpowers | Comprehensive branch cleanup before merge. | Before merging a long-lived feature branch. |
| `/using-git-worktrees` | superpowers | Manages parallel work using git worktrees. | Working on multiple branches simultaneously. |

---

## Agent Management Commands

| Command | Plugin | What It Does | When to Use |
|---------|--------|--------------|-------------|
| `/agent-setup` | claude-mcp-ecosystem | Initial deployment of specialist agents for a project. | First time setting up agents. |
| `/agent-status` | claude-mcp-ecosystem | Health check on deployed agents. | Periodic check or when agents seem broken. |
| `/agent-diagnose` | claude-mcp-ecosystem | Deep diagnostic on a failing agent. | When an agent isn't working. |
| `/agent-add` | claude-mcp-ecosystem | Adds a new specialist agent. | Need a new domain expert. |
| `/agent-remove` | claude-mcp-ecosystem | Removes an agent from the roster. | Agent no longer needed. |
| `/agent-reset` | claude-mcp-ecosystem | Resets entire agent ecosystem. Nuclear option. | Agent roster corrupted or needs fresh start. |

---

## The 10 Automatic Hooks (Fire Without Commands)

| # | Event | Name | What It Blocks/Does |
|---|-------|------|---------------------|
| 1 | SessionStart | Project scanner | Reports project state on every session open |
| 2 | PreToolUse | Branch protector | Blocks commits to main/master |
| 3 | PreToolUse | File blocker | Blocks staging state/, .env, .DS_Store, __pycache__/ |
| 4 | PreToolUse | Doc checker | Blocks commit if CLAUDE.md, README.md, or docs/DEVOPS-HANDOFF.md missing |
| 5 | PreToolUse | Secret scanner | Blocks commit if API keys/tokens in staged files |
| 6 | PreToolUse | Nested repo detector | Blocks git add if nested .git directories found |
| 7 | PreToolUse | Push safety | Blocks push if uncommitted files exist |
| 8 | PostToolUse | File watcher | Suggests relevant skill after Write/Edit operations |
| 9 | Stop | Pre-stop checker | Blocks session exit if uncommitted files exist |
| 10 | PreCompact | State preserver | Confirms task state exists before context compaction |

---

## Passive Plugins (No Commands — Always Active)

| Plugin | What It Does |
|--------|--------------|
| agent-teams | Parallel agent pipeline engine used by `/build` |
| pyright-lsp | Python type checking — runs in background |
| security-guidance | Security warnings on file edits |
| explanatory-output-style | Adds insight boxes explaining WHY decisions were made |
| github | MCP server providing GitHub API tools |
| learn | Skill discovery |
| claude-code-research | Reference documentation for Claude Code internals |

---

## Typical Session Flows

### New Project (first time)
```
cd ~/projects/my-new-project && claude
# SessionStart hook fires, reports missing files
/prime                              # Boot session
/claude-automation-recommender      # Analyze codebase, get recommendations
/revise-claude-md                   # Create CLAUDE.md
/agent-setup                        # Deploy specialist agents
/plan Build feature X               # Plan the work
/build                              # Execute with agent teams
/code-review                        # Review the diff
/commit-push-pr                     # Ship it
/wrap                               # Close session
```

### Existing Project (returning)
```
cd ~/projects/my-project && claude
# SessionStart hook fires, reports all-clear
/prime                              # Boot — loads lessons, agents, git state
/plan Next task description         # Plan
/build                              # Build
/commit-push-pr                     # Ship
/wrap                               # Close
```

### Quick Fix (single change)
```
cd ~/projects/my-project && claude
/prime
# Just describe the fix in plain language — no /plan needed
"Fix the bug in auth.py where tokens expire early"
/commit-push-pr
/wrap
```

### Code Review Only
```
cd ~/projects/my-project && claude
/prime
/code-review                        # Review current diff
# or
/review-pr 42                       # Review PR #42
/wrap
```
