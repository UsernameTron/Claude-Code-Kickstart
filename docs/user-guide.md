# Claude Code Kickstart — Beginner's User Guide

> Your complete guide to the slash command system, agent architecture, and development lifecycle.

---

## Table of Contents

1. [What Is This?](#what-is-this)
2. [The 5-Minute Mental Model](#the-5-minute-mental-model)
3. [Your First Session](#your-first-session)
4. [The Daily Loop (5 Commands)](#the-daily-loop)
5. [Command Reference by Phase](#command-reference-by-phase)
6. [Understanding the Agent System](#understanding-the-agent-system)
7. [Decision Trees — Which Command Do I Use?](#decision-trees)
8. [Hooks — Your Invisible Safety Net](#hooks)
9. [Common Scenarios](#common-scenarios)
10. [Troubleshooting](#troubleshooting)

---

## What Is This?

Claude Code Kickstart is a governance framework that turns Claude Code from a conversational AI into a **structured development pipeline**. It gives you:

- **Slash commands** — typed shortcuts (like `/plan`, `/build`, `/commit`) that trigger complex workflows
- **Agent teams** — autonomous AI workers that build, test, review, and secure your code in parallel
- **Hooks** — invisible safety rules that prevent mistakes before they happen
- **Session lifecycle** — a repeatable open-plan-build-ship-close loop

**You describe what you want in plain English. The system figures out the technical execution.**

---

## The 5-Minute Mental Model

Think of it like managing a software team, except the team is AI agents:

```
YOU (vibecoder)
  │
  ├── "I want auth, dashboard, and notifications"
  │
  ▼
/plan  ──────►  Creates a structured plan
  │
  ▼
/build  ─────►  Spawns an AGENT TEAM:
  │               ├── Team Lead (orchestrator — never writes code)
  │               ├── Feature Agent 1 (auth)
  │               ├── Feature Agent 2 (dashboard)
  │               ├── Feature Agent 3 (notifications)
  │               ├── Quality Agent (runs tests independently)
  │               ├── Code Review Agent (blocks bad code)
  │               ├── Security Agent (OWASP scanning)
  │               └── Merger Agent (creates PRs)
  │
  ▼
/commit-push-pr  ►  Ships the code
  │
  ▼
/wrap  ──────►  Logs what happened, captures learnings
```

Every feature goes through a **10-step TDD pipeline** automatically. You don't manage the steps — the agents do.

---

## Your First Session

### Step 1: Install

```bash
git clone https://github.com/UsernameTron/Claude-Code-Kickstart.git
cd Claude-Code-Kickstart
./install.sh
```

The installer copies templates, settings, hooks, and plugins to your `~/.claude/` directory.

### Step 2: Create a Project

```bash
bash scripts/scaffold-project.sh my-new-app
cd my-new-app
```

This creates a project with the standard directory structure:

```
my-new-app/
├── CLAUDE.md              # Project governance (how Claude behaves)
├── README.md              # What this project is
├── tasks/
│   ├── todo.md            # Current plan and progress
│   └── lessons.md         # Rules learned from corrections
├── _project_specs/
│   └── features/          # Feature specifications
├── .claude/
│   ├── settings.json      # Permissions, hooks, env vars
│   └── agents/            # Agent definitions
└── docs/
    └── DEVOPS-HANDOFF.md  # Deployment documentation
```

### Step 3: Open Claude Code and Boot

```bash
claude
```

Then type:

```
/prime
```

This is the most important command. It loads your project context, checks git state, reads lessons from past sessions, and reports what's ready.

**Always start every session with `/prime`.** It's the ignition key.

---

## The Daily Loop

Every development session follows this 5-command loop:

```
/prime  →  /plan  →  /build  →  /commit-push-pr  →  /wrap
```

| Step | Command | What It Does | You Say |
|------|---------|--------------|---------|
| 1 | `/prime` | Boot session, load context | "Start working" |
| 2 | `/plan` | Create a structured plan | "Build X, Y, and Z" |
| 3 | `/build` | Execute the plan with agents | "Go" |
| 4 | `/commit-push-pr` | Ship to GitHub | "Ship it" |
| 5 | `/wrap` | Log session, note learnings | "Done for now" |

That's it. Five commands cover 90% of your workflow.

---

## Command Reference by Phase

### Phase 0 — Bootstrap (First Time Only)

Run these once when setting up a new project. They establish the infrastructure that all other commands depend on.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/claude-automation-recommender` | Scans your codebase and recommends which Claude Code features to enable (hooks, agents, skills, MCP servers). | First session in a new project. |
| `/claude-md-improver` | Audits your CLAUDE.md file and scores it 0-100. Identifies missing sections and suggests improvements. | When CLAUDE.md feels incomplete or stale. |
| `/hookify` | Generates project-specific hook rules that enforce quality automatically. Creates `.claude/hookify.{name}.local.md` files. | After CLAUDE.md is set up, before you start building. |
| `/configure` | Interactive configuration for hookify rules. Toggle rules on/off. | Fine-tuning which hooks fire. |
| `/agent-setup` | Deploys specialist agents for your project. Analyzes codebase, designs agent roster, creates agent files with memory. | When you want persistent specialist agents. |

**Example first-time setup:**
```
/prime
/claude-automation-recommender
/claude-md-improver
/hookify
/agent-setup
```

After this, your project has governance (CLAUDE.md), safety (hooks), and intelligence (agents) — all configured for your specific codebase.

---

### Phase 1 — Planning (Every Feature)

Never build without a plan. These commands create and refine plans before any code is written.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/prime` | Boots the session. Loads CLAUDE.md, lessons, todo, agents, git state. Reports status. | **Always first. Every session.** |
| `/plan <request>` | Creates a structured plan in `tasks/todo.md`. Assesses complexity (simple/standard/complex). Determines whether to use Agent Teams or subagents. | Before any multi-step work. |
| `/brainstorming` | Explores context, asks clarifying questions one at a time, proposes 2-3 approaches, presents a design for approval. | Complex features that need creative exploration. |
| `/writing-plans` | Converts an approved design into a detailed TDD plan with acceptance criteria and test case tables. | After brainstorming, for standard/complex features. |
| `/status` | Dashboard showing task progress, git state, agent health, and work status. | Anytime during a session — your progress report. |

**How planning scales with complexity:**

- **Simple** (1-3 steps): `/plan` alone is enough. Skip brainstorming.
  - Example: "Add a health check endpoint"
- **Standard** (4-10 steps): `/plan` → `/brainstorming` → approve
  - Example: "Add user authentication with JWT"
- **Complex** (10+ steps): `/plan` → `/brainstorming` → `/writing-plans` → approve
  - Example: "Build a real-time notification system with WebSockets"

**Example:**
```
/prime
/plan Build user authentication with email/password login, JWT tokens, and password reset
```

Claude creates the plan, assesses complexity, and asks for approval. Say "approved" or "looks good" to proceed.

---

### Phase 2 — Building (Where Code Gets Written)

These commands execute your approved plan. The system chooses the right execution strategy automatically.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/build` | Executes the approved plan. Spawns Agent Teams for 2+ features, subagents for single features. Runs the 10-step TDD pipeline per feature. | After plan is approved. This is THE build command. |
| `/dispatching-parallel-agents` | Manually spawns parallel subagents for custom tasks you define. | When `/build` doesn't fit your workflow. |
| `/subagent-driven-development` | Single-feature development with one subagent per task and two-stage review. | Single features with 3+ subtasks. |
| `/test-driven-development` | Enforces strict RED-GREEN-REFACTOR cycle in the current context. | When you want hands-on TDD without agents. |
| `/systematic-debugging` | Structured debugging: reproduce, isolate, diagnose, fix, verify. Runs in an isolated subagent. | When something is broken and you can't figure out why. |
| `/ralph-loop` | Continuous autonomous development loop — keeps working until done. | Long-running tasks you want to walk away from. |
| `/cancel-ralph` | Stops a running ralph-loop. | When you need to interrupt. |

**How the system decides what to run:**

```
2+ features?  ──► Agent Teams (parallel feature chains)
1 feature, 3+ tasks?  ──► Subagent-driven development
1 task, simple?  ──► Direct implementation (no agents)
```

You don't need to decide — `/build` figures it out from your plan.

**Example:**
```
/build
```

That's it. The Team Lead reads your plan, spawns Feature Agents, and the pipeline runs.

---

### Phase 2.5 — Extension Generation (Code Factory)

These commands generate new Claude Code extensions (skills, hooks, agents, plugins) from natural language descriptions. Use these when you want to customize how Claude Code works.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/cc-factory` | Main generator. Creates skills, hooks, agents, or plugins from a description. | "Create a skill that validates YAML files" |
| `/extension-concierge` | Non-technical entry point. Asks clarifying questions, then routes to the right generator. | When you're not sure what type of extension you need. |
| `/smart-scaffold` | Quick prototyping. Classifies your request by tier and generates the minimum viable extension. | Fast iteration on extension ideas. |
| `/agent-factory` | Generates agent `.md` files with correct frontmatter and system prompts. | "Create an agent that reviews database queries" |
| `/hook-factory` | Generates hook configurations from descriptions. | "Block commits that contain console.log" |
| `/skill-factory` | Generates SKILL.md files from descriptions. | "Create a skill for generating API docs" |
| `/extension-fixer` | Diagnoses and repairs broken extensions. | When a skill isn't triggering or an agent has errors. |
| `/dev-recipes` | Browse 86 pre-built agent recipes by domain. | "Show me recipes for Python backend development" |
| `/scenario-library` | Browse 40 pre-built extension recipes. | "What hook patterns are available?" |

**Example:**
```
/cc-factory Create a hook that runs ESLint after every file edit
```

---

### Phase 3 — Quality & Review

These commands verify code quality. Most quality gates run automatically inside the agent pipeline, but you can trigger additional reviews manually.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/code-review` | Deploys 5 parallel review agents against the current diff. Rates issues by severity with confidence scores. | After `/build` completes, before shipping. |
| `/review-pr` | Reviews a specific GitHub PR with 6 specialized agents (comments, tests, silent failures, types, quality, simplification). | Reviewing any PR before merge. |
| `/requesting-code-review` | Prepares your code for human review. Writes a review request with full context. | When you want a human to review your work. |
| `/receiving-code-review` | Processes feedback from a code review and applies fixes systematically. | After receiving review comments. |
| `/verification-before-completion` | Final verification gate. Prevents you from claiming work is done without evidence. | Before marking any task as complete. |

**Built-in quality gates (automatic, no command needed):**

The Agent Teams pipeline includes 5 quality gates that run automatically:
1. **Step 4 — RED verify**: Quality Agent confirms all new tests fail before implementation
2. **Step 6 — GREEN verify**: Quality Agent confirms all tests pass with >= 90% coverage
3. **Step 7 — Validate**: Linter + type checker + full test suite
4. **Step 8 — Code Review**: Code Review Agent blocks on Critical/High issues
5. **Step 9 — Security**: Security Agent blocks on Critical/High findings (OWASP)

---

### Phase 4 — Ship

These commands handle git operations — committing, pushing, and creating PRs.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/commit` | Creates a single conventional commit on the current branch. Analyzes the diff and writes the message. | Quick commits during development. |
| `/commit-push-pr` | Commits + pushes + creates a GitHub PR — all in one command. Writes the PR title, summary, and test plan. | Standard shipping command. The one you'll use most. |
| `/clean-gone` | Deletes local branches whose remote tracking branch has been deleted (merged and cleaned up on GitHub). | After merging PRs — keeps your local repo clean. |
| `/finishing-a-development-branch` | Comprehensive branch cleanup with 4 options: merge, push PR, keep working, or discard. Verifies tests on merged result. | When finishing a long-lived feature branch. |
| `/using-git-worktrees` | Manages parallel development using git worktrees. Isolates feature work without switching branches. | Working on multiple features simultaneously. |

**Example:**
```
/commit-push-pr
```

Claude analyzes all changes, writes a commit message, creates a branch, pushes, and opens a PR with a summary and test plan.

---

### Phase 5 — Session Close

Always close your session properly. These commands preserve context for the next session.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/wrap` | Closes the session. Logs what was done to `state/session-log.md`, records design decisions, updates `tasks/todo.md` with a handoff note for the next session. | **Always last. Every session.** |
| `/revise-claude-md` | Captures session learnings into the project CLAUDE.md. Updates architecture docs, conventions, test counts. | After sessions where you learned something about the project. |

**Example:**
```
/wrap
```

If you have uncommitted files, the Stop hook will block `/wrap` — you must commit or discard changes first.

---

### Agent Management (Anytime)

These commands manage the persistent specialist agents in your project.

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `/agents` | Lists all deployed specialist agents with their status and capabilities. | Quick overview of your agent roster. |
| `/agent-status` | Health check on all agents. Checks memory files, frontmatter, tool access. | When agents seem slow or broken. |
| `/agent-diagnose` | Deep diagnostic on a specific failing agent. Identifies root cause. | When `/agent-status` shows issues. |
| `/agent-add` | Adds a new specialist agent to your project. | When you need a new domain expert. |
| `/agent-remove` | Removes an agent from the roster. | When an agent is no longer needed. |
| `/agent-reset` | Resets an agent's memory. Keeps the agent definition, clears learned context. | When an agent's memory has become stale or corrupted. |

---

## Understanding the Agent System

### Three Types of Agents

The system uses three different agent architectures, each for different situations:

#### 1. Agent Teams (the main build engine)

Used by `/build` for 2+ features. Spawns a full team:

| Agent | Role | Writes Code? | Model |
|-------|------|:---:|-------|
| Team Lead | Orchestrates, delegates, monitors | No | Opus |
| Feature Agent (x N) | Writes specs, tests, and code | **Yes** | Sonnet or Opus |
| Quality Agent | Runs tests independently, checks coverage | No | Haiku |
| Code Review Agent | Reviews code, blocks on Critical/High | No | Sonnet |
| Security Agent | OWASP scanning, secrets detection | No | Haiku |
| Merger Agent | Creates branches and PRs | No | Haiku |

**Key insight**: Only Feature Agents write code. All other agents are verification-only. They never trust each other's reports — they verify independently.

#### 2. Subagents (for single features and reviews)

Individual Claude instances spawned for one task. They get a clean context, do their job, and terminate. The main session stays clean.

Used by:
- `/subagent-driven-development` — one subagent per task
- `/code-review` — 5 parallel review subagents
- `/systematic-debugging` — isolated debugging subagent

#### 3. MCP Ecosystem Agents (persistent specialists)

Custom agents that persist across sessions with memory. They know your project because they remember previous work.

Managed by: `/agent-setup`, `/agent-status`, `/agent-add`, `/agent-diagnose`

### The 10-Step TDD Pipeline

Every feature — whether built by Agent Teams or subagents — follows this pipeline:

| Step | Name | Who | What Happens |
|------|------|-----|--------------|
| 1 | SPEC | Feature Agent | Writes feature specification |
| 2 | SPEC REVIEW | Quality Agent | Reviews spec for completeness |
| 3 | WRITE TESTS | Feature Agent | Writes failing tests for all acceptance criteria |
| 4 | RED VERIFY | Quality Agent | Independently confirms all tests fail |
| 5 | IMPLEMENT | Feature Agent | Writes minimum code to pass tests |
| 6 | GREEN VERIFY | Quality Agent | Independently confirms all tests pass (>= 90% coverage) |
| 7 | VALIDATE | Feature Agent | Runs linter + type checker + full suite |
| 8 | CODE REVIEW | Code Review Agent | Reviews code, blocks on Critical/High |
| 9 | SECURITY | Security Agent | OWASP scan, blocks on Critical/High |
| 10 | BRANCH + PR | Merger Agent | Creates feature branch and PR |

Steps are enforced by **task dependencies** — Step 5 literally cannot start until Step 4 is verified. This is structural, not advisory.

---

## Decision Trees

### "I want to build something"

```
Is it a one-line fix or config tweak?
  └─► Just do it directly. Use /commit when done.

Is it a single, simple feature (< 3 files)?
  └─► /plan → approve → implement directly → /commit-push-pr

Is it a single complex feature (3+ tasks)?
  └─► /plan → /brainstorming → approve → /build (uses subagents)

Is it multiple features or a full app?
  └─► /plan → /brainstorming → /writing-plans → approve → /build (uses Agent Teams)
```

### "Something is broken"

```
Is the error message clear?
  └─► Fix it directly. Log in tasks/lessons.md.

Is it confusing or deep?
  └─► /systematic-debugging (runs in isolated subagent)

Did an agent break?
  └─► /agent-status → /agent-diagnose

Did a hook break?
  └─► /hookify list → /configure
```

### "I want to customize Claude Code"

```
Need a new slash command?
  └─► /skill-factory

Need automatic behavior on file changes?
  └─► /hook-factory

Need a specialist AI agent?
  └─► /agent-factory or /agent-add

Need a full plugin with multiple components?
  └─► /cc-factory or /extension-concierge

Not sure what type?
  └─► /extension-concierge (asks clarifying questions)
```

---

## Hooks — Your Invisible Safety Net

Hooks are shell commands that run automatically before or after Claude Code operations. You never invoke them — they fire on their own.

### The 10 Built-In Hooks

| # | When | What It Prevents |
|---|------|------------------|
| 1 | Session start | Reports project state automatically |
| 2 | Before git commit | Blocks commits directly to main/master |
| 3 | Before git add | Blocks staging of `state/`, `.env`, `.DS_Store`, `__pycache__/` |
| 4 | Before git commit | Blocks commit if `CLAUDE.md`, `README.md`, or `DEVOPS-HANDOFF.md` is missing |
| 5 | Before git commit | Blocks commit if staged files contain API keys or tokens |
| 6 | Before git add | Blocks if nested `.git` directories would be added |
| 7 | Before git push | Blocks push if uncommitted files exist |
| 8 | After file write/edit | Suggests relevant skills for the file type you just modified |
| 9 | Before session end | Blocks exit if uncommitted changes exist |
| 10 | Before context compaction | Preserves task state before Claude's memory is compressed |

**You don't need to remember these.** They protect you silently. If a hook blocks an operation, Claude tells you why and what to do.

---

## Common Scenarios

### Scenario 1: "I'm starting a brand new project"

```
# In terminal:
bash scripts/scaffold-project.sh my-app
cd my-app
claude

# In Claude Code:
/prime
/claude-automation-recommender
/claude-md-improver
/hookify
/agent-setup
/wrap
```

### Scenario 2: "I want to add a feature"

```
/prime
/plan Add user profile pages with avatar upload and bio editing
# Wait for plan → approve it
/build
# Wait for pipeline to complete
/commit-push-pr
/wrap
```

### Scenario 3: "I want to build a full app from scratch"

```
/prime
/plan Build a task management API with auth, CRUD operations, and real-time notifications
/brainstorming
# Answer questions, approve design
/writing-plans
# Approve detailed plan
/build
# Agent Teams runs 3 parallel feature chains
/code-review
/commit-push-pr
/wrap
```

### Scenario 4: "I need to fix a bug"

```
/prime
# Describe the bug
/systematic-debugging
# Follow the debugging steps
/commit
/wrap
```

### Scenario 5: "I want to review a PR"

```
/prime
/review-pr 42
# Read the 6-agent review report
# Apply fixes if needed
/wrap
```

### Scenario 6: "I want to create a custom Claude Code extension"

```
/prime
/cc-factory Create a hook that validates all SQL queries before execution
# Or for guided help:
/extension-concierge
/wrap
```

### Scenario 7: "Quick fix — just a typo or config change"

```
/prime
# Make the fix directly
/commit
/wrap
```

No plan needed. No agents. Just fix, commit, close.

---

## Troubleshooting

### "My agent isn't responding"

```
/agent-status     # Check health
/agent-diagnose   # Deep diagnostic
/agent-reset      # Nuclear option — clears memory
```

### "A hook is blocking me and I don't know why"

```
/hookify list     # See all active rules
/configure        # Toggle rules on/off
```

### "Claude forgot what we were doing"

```
/prime            # Reloads all context
/status           # Shows current state
```

Context compaction can clear earlier conversation. `/prime` reloads everything from files.

### "The build failed partway through"

The system saves progress to `tasks/todo.md`. When you restart:

```
/prime            # Detects partial progress
/build            # Resumes from last checkpoint
```

### "I want to undo everything from this session"

```
git stash         # Save uncommitted changes
git log --oneline # Find the commit before your session
git reset --soft HEAD~N  # Undo N commits (keeps files)
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────┐
│           CLAUDE CODE KICKSTART                 │
│           Quick Reference Card                  │
├─────────────────────────────────────────────────┤
│                                                 │
│  EVERY SESSION:                                 │
│    /prime  → /plan → /build → /commit → /wrap   │
│                                                 │
│  FIRST TIME:                                    │
│    /claude-automation-recommender                │
│    /claude-md-improver                          │
│    /hookify                                     │
│    /agent-setup                                 │
│                                                 │
│  BUILDING:                                      │
│    /plan <what you want>    Plan it              │
│    /build                   Build it             │
│    /commit-push-pr          Ship it              │
│                                                 │
│  QUALITY:                                       │
│    /code-review             Review diff          │
│    /review-pr <number>      Review a PR          │
│    /systematic-debugging    Fix a bug            │
│                                                 │
│  AGENTS:                                        │
│    /agents                  List agents          │
│    /agent-status            Health check         │
│    /agent-add               Add specialist       │
│                                                 │
│  EXTENSIONS:                                    │
│    /cc-factory              Generate extension   │
│    /extension-concierge     Guided creation      │
│    /dev-recipes             Browse recipes       │
│                                                 │
│  GIT:                                           │
│    /commit                  Single commit        │
│    /commit-push-pr          Full ship            │
│    /clean-gone              Cleanup branches     │
│                                                 │
│  INFO:                                          │
│    /status                  Dashboard            │
│    /prime                   Reload context       │
│    /wrap                    End session           │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Architecture Diagrams

### System Architecture — 5-Phase Lifecycle

Shows how installation, bootstrap, planning, building, quality gates, shipping, and session close connect. The 10 automatic hooks enforce safety at every step.

[View and edit the lifecycle diagram](https://l.mermaid.ai/h8F1Ot)

### Agent Teams — 10-Step TDD Pipeline

Shows how the 6 agent roles interact during a build: User triggers Team Lead, who spawns Feature Agents. Each feature moves through SPEC → RED → GREEN → REVIEW → SECURITY → SHIP with independent verification at every gate.

[View and edit the pipeline diagram](https://l.mermaid.ai/nskFX8)

---

## Glossary

| Term | Definition |
|------|-----------|
| **Agent Teams** | The primary build engine — 5 permanent agents + N feature agents running parallel TDD pipelines |
| **Feature Agent** | The only agent that writes code. One per feature, follows the 10-step pipeline. |
| **Hook** | A shell command that fires automatically before/after Claude Code operations |
| **MCP** | Model Context Protocol — connects Claude Code to external tools (GitHub, databases, etc.) |
| **Pipeline** | The 10-step sequence: spec → review → tests → red → implement → green → validate → code review → security → branch+PR |
| **Slash command** | A `/command` you type to trigger a workflow (like `/plan` or `/build`) |
| **Skill** | A SKILL.md file that teaches Claude a new capability |
| **Subagent** | A temporary Claude instance spawned for one task, then terminated |
| **TDD** | Test-Driven Development — write tests first, then implement |
| **Vibecoder** | Someone who describes what they want in plain language and lets the system handle execution |
