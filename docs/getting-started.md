# Getting Started with Claude Code Kickstart

## Prerequisites

- **Claude Code** installed and working (`claude --version`)
- **Claude Max subscription** (recommended for Agent Teams)
- **Git** installed
- **Python 3.10+** installed
- A GitHub account

---

## Step 1: Install Kickstart

```bash
git clone https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart.git
cd claude-code-kickstart
./install.sh
```

Follow the prompts to enter your name, GitHub username, and optional details.

## Step 2: Verify Installation

```bash
bash scripts/health-check.sh
```

All 11 checks should pass. If any fail, see [troubleshooting.md](troubleshooting.md).

## Step 3: Open Claude Code in Any Project

```bash
cd ~/your-project
claude
```

The **SessionStart hook** automatically scans your project and reports what's present (git, CLAUDE.md, tests, agents, etc.).

## Step 4: Boot the Session

```
/prime
```

This loads context, lessons, task state, deployed agents, and git status. Run this at the start of every session.

## Step 5: Plan a Feature

```
/plan Build a REST API with user authentication and file uploads
```

The planner assesses complexity (simple/standard/complex) and creates a plan in `tasks/todo.md`. Review and approve before building.

## Step 6: Build It

```
/build
```

For multi-component work, Agent Teams spawns parallel Feature Agents. Each follows the 10-step TDD pipeline:
1. Spec
2. Spec Review
3. Write Tests
4. RED Verify
5. Implement
6. GREEN Verify
7. Validate
8. Code Review
9. Security Scan
10. Branch + PR

## Step 7: See the Hooks Work

Try these to see automatic enforcement:
- **Commit to main:** Blocked. "Create a feature branch first."
- **Stage .env file:** Blocked. "Private/generated files should be in .gitignore."
- **Commit without docs:** Blocked. "Missing required docs: CLAUDE.md, README.md, docs/DEVOPS-HANDOFF.md."
- **Push with uncommitted files:** Blocked. "Commit before pushing."

## Step 8: Ship It

```
/commit-push-pr
```

Creates a feature branch, commits, pushes, and opens a PR in one command.

## Step 9: Close the Session

```
/wrap
```

Logs work, records decisions, updates tasks/todo.md with handoff notes. The Stop hook verifies your working tree is clean.

## Step 10: Start a New Project

```bash
mkdir ~/new-project && cd ~/new-project
bash ~/path/to/claude-code-kickstart/scripts/scaffold-project.sh
claude
```

The scaffold script creates the standard directory structure with CLAUDE.md, README.md, .gitignore, tasks/lessons.md, and docs/DEVOPS-HANDOFF.md.

## Step 11: Set Up Agent Specialists (Optional)

```
/agent-setup
```

The MCP Ecosystem scans your project and recommends specialist agents. The concierge handles deployment automatically.

## Step 12: Explore Extensions

Use the Code Factory to generate custom extensions:
- `/cc-factory` -- Generate skills, hooks, agents, plugins from natural language
- `/scenario-library` -- Browse 40+ pre-built extension recipes
- `/dev-recipes` -- Quick recipe patterns for common needs

---

## Daily Workflow Summary

```
/prime -> /plan -> /build -> /commit-push-pr -> /wrap
```

That's it. Five commands for a complete development session with automatic quality gates, testing, security scanning, and documentation enforcement.
