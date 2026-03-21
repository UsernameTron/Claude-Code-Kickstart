# Global Claude Code Configuration

> Loads at session start for all projects. This is the operating system for every Claude Code session.

---

## Identity

- Python for data/automation, JavaScript for frontend
- Extended thinking for architectural decisions, complex debugging, and "think"/"analyze deeply"
- Concise by default; expand when asked
- Absolute paths when referencing files
- For multi-step tasks, show a brief plan before starting
- When implementing code, explain WHY you made each significant design choice — not just WHAT you built. The operator understands architecture but delegates implementation. Explanations of trade-offs, pattern choices, and alternatives considered are more valuable than line-by-line code commentary.

---

## Environment

Required for agent-teams pipeline:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Set in `~/.claude/settings.json` or project `.claude/settings.local.json`.

---

## Session Commands

| Command | When | What it does |
|---------|------|--------------|
| `/prime` | Session start | Boot session — load context, lessons, task state, agents, git status |
| `/plan <request>` | Before building | Create implementation plan scaled to complexity |
| `/build [plan-path]` | After plan approved | Execute plan with git branches, step-by-step commits |
| `/status` | Anytime | Dashboard — task progress, git state, agents, lessons count |
| `/wrap` | Session end | Log work, record decisions, note next steps |
| `/commit` | After verified work | Quick single commit |
| `/commit-push-pr` | Ship to remote | Branch + commit + push + PR in one shot |
| `/clean-gone` | Branch cleanup | Remove stale local branches deleted on remote |
| `/revise-claude-md` | Session end | Capture session learnings into project CLAUDE.md |
| `/agents` | Anytime | List deployed specialists |
| `/agent-setup` | Phase 0 | Initial agent deployment |
| `/agent-status` | Anytime | Agent health check |
| `/agent-diagnose` | When broken | Diagnose agent issues |

---

## Session Initialization (Every Session)

On every session start, execute before doing ANY work:

1. Read this file in full
2. Read `tasks/lessons.md` — if missing, create from template at bottom of this file
3. Read `tasks/todo.md` — if a task is in progress, summarize current state
4. Load operator context files if they exist: `context/role.md`, `context/org.md`, `context/priorities.md`, `context/metrics.md`
5. Check `.claude/agents/` for deployed specialists
6. Check git state (branch, uncommitted changes, last commit)
7. Report: "Session initialized. [N] lessons loaded. [Task status]. [N] specialists. Branch: [name] [clean/dirty]."

Do not skip this sequence. `/prime` automates it.

---

## Development Lifecycle

All development follows this phased protocol. Phases are sequential gates.

### Phase 0 — Bootstrap (once per new project)

Run on first session in any new project:

1. **claude-code-setup** — Scan codebase, recommend hooks, skills, MCP servers, subagents.
2. **claude-md-management** — Audit or create project CLAUDE.md. Score against quality criteria.
3. **hookify** — Write project-specific rules as `.claude/hookify.{name}.local.md` files.
4. **security-guidance** — Activates automatically on file edits.
5. **MCP Ecosystem: project-guide** — Auto-detects whether project needs agent setup. Routes to concierge if yes.
6. **Agent-teams setup** — Verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set. Ensure `.claude/agents/` has team definitions (team-lead.md, quality.md, security.md, code-review.md, merger.md, feature.md).

Done when: CLAUDE.md scored, hooks in place, agent ecosystem ready, team definitions deployed.

### Phase 1 — Planning (each feature)

7. `/plan <request>` — Creates high-level plan in `tasks/todo.md`. Assesses complexity (simple/standard/complex). Presents for approval. **No building until approved.**
8. **superpowers:brainstorming** — For standard/complex features: explore context → ask one question at a time → propose 2-3 approaches → present design → write spec to `_project_specs/features/{feature-name}.md` → spec-reviewer subagent validates → user approves.
9. **superpowers:writing-plans** — Convert approved spec into TDD plan with acceptance criteria and test cases table. Plan-reviewer subagent validates.

Simple tasks (1-3 steps): `/plan` alone is sufficient.
Standard/complex tasks: full brainstorming → writing-plans pipeline.

Done when: spec committed with acceptance criteria and test cases, plan approved.

### Phase 2 — Implementation: Agent Execution Strategy

**HARD RULE — MANDATORY AGENT USE**

This is not optional. This is not guidance. This is a hard rule that survives compaction:

- 2+ features or components → MUST use Agent Teams with parallel chains. No exceptions.
- Single feature with 3+ tasks → MUST use subagent-driven-development. No exceptions.
- Code review → MUST dispatch parallel review subagents. No exceptions.
- Never implement multiple independent features sequentially in the main context. If you catch yourself doing this, STOP immediately, spawn the agent team, and restart with parallel chains.
- When in doubt about whether to use agents: USE AGENTS. The cost of unnecessary agents is a few extra minutes. The cost of skipping agents is quality gaps, context pollution, and sequential bottlenecks.

Violation of this rule must be logged in tasks/lessons.md as a correction.

The operator is a vibecoder. He describes what he wants in plain language. The system figures out the technical execution. The default execution mode is always the most parallel option available. Never implement sequentially when parallel execution is possible.

#### Three execution systems — know when to use each

**System 1: Agent Teams (default for any multi-component work)**

Agent Teams is the primary build engine. It spawns a full development team of 5 permanent agents plus one Feature Agent per component. Features execute their 10-step TDD pipelines in parallel. This is the default for any work involving 2 or more independent components.

The 5 permanent agents:
- **Team Lead** — Orchestrator. Reads feature specs, breaks work into dependency chains, spawns Feature Agents, monitors progress, coordinates cross-feature dependencies. Delegate mode only — never writes code, never touches files.
- **Quality Agent** — TDD enforcer. Reviews spec completeness (Step 2), verifies all tests FAIL before implementation (Step 4 RED), verifies all tests PASS after implementation with coverage ≥90% overall, no module below 80%, security-critical modules ≥95% (Step 6 GREEN). Independently runs tests — never trusts Feature Agent's self-report.
- **Code Review Agent** — Multi-engine reviewer. Runs after validation passes. Blocks on Critical or High severity issues. Feature Agent must fix and re-request. Only approves when code meets standards.
- **Security Agent** — OWASP scanner. Runs secrets detection, dependency audit, injection checks. Blocks on Critical or High findings. No code reaches PR without security clearance.
- **Merger Agent** — Branch and PR manager. Creates feature branches, stages only feature-specific files (never git add -A), creates PRs via gh CLI with full template (spec summary, test results, review summary, security results). Never merges — only creates PRs for human review.

Dynamic agents:
- **Feature Agent (xN)** — One per feature/component. Each follows the immutable 10-step pipeline end-to-end. This is the only agent that writes code. Uses the superpowers:systematic-debugging skill when blocked.

The immutable 10-step pipeline per feature:

Step 1:  SPEC — Feature Agent writes specification (or adopts Phase 1 spec from _project_specs/features/)
Step 2:  SPEC REVIEW — Quality Agent reviews spec for completeness, testability, and acceptance criteria
Step 3:  WRITE TESTS — Feature Agent writes failing tests covering ALL acceptance criteria
Step 4:  RED VERIFY — Quality Agent independently runs tests, confirms ALL new tests FAIL (no false greens)
Step 5:  IMPLEMENT — Feature Agent writes minimum code to make all tests pass. TDD discipline: no code without a failing test driving it
Step 6:  GREEN VERIFY — Quality Agent independently runs full suite, confirms ALL pass, checks coverage ≥90% overall, no module below 80%, security-critical modules ≥95%
Step 7:  VALIDATE — Feature Agent runs linter + type checker + full test suite. Fixes any issues.
Step 8:  CODE REVIEW — Code Review Agent reviews. Blocks on Critical/High. Feature Agent fixes and re-requests until approved.
Step 9:  SECURITY SCAN — Security Agent scans. Blocks on Critical/High. Feature Agent fixes and re-requests until approved.
Step 10: BRANCH + PR — Merger Agent creates feature branch, stages files, creates PR with full documentation.

Task dependencies make it structurally impossible to skip steps. A Feature Agent cannot see "implement" until Quality Agent completes "RED verify." Code Review cannot start until "validate" passes. This is not advisory — it is enforced.

Parallel execution — how multiple features run simultaneously:

When the Team Lead has 3 features (e.g., auth, dashboard, payments), it creates 3 Feature Agents and 30 tasks total (10 per feature). All 3 Feature Agents begin their Step 1 (spec) simultaneously. As each Feature Agent completes a step, the shared agents (Quality, Security, Review, Merger) pick up the next gate task from whichever chain unblocked first. The shared agents process tasks in FIFO order across all chains.

Example parallel timeline:
- T=0: Feature-Auth starts spec, Feature-Dashboard starts spec, Feature-Payments starts spec
- T=5min: Feature-Auth finishes spec → Quality Agent picks up auth spec review
- T=6min: Feature-Dashboard finishes spec → Quality Agent queues dashboard spec review (processes after auth)
- T=8min: Auth spec review done → Feature-Auth starts writing tests. Quality Agent starts dashboard spec review.
- T=10min: Feature-Payments finishes spec → Quality Agent queues payments spec review
- ...continues with all chains advancing independently

The Team Lead monitors all chains. If Feature-Auth is blocked by a failing review while Feature-Dashboard is progressing, no resources are wasted waiting — the shared agents serve whichever chain needs them next.

When to use Agent Teams:
- 2+ independent features or components to build
- Full application builds (frontend + backend + tests)
- Any project where you describe multiple things that need to exist
- Refactors that touch multiple independent modules

How to invoke: Describe the features. The Team Lead handles everything else.
- "Build auth, dashboard, and alerting" → Team Lead spawns 3 Feature Agents, runs 3 parallel chains
- "I need a REST API with user management, file uploads, and notifications" → 3 features, 3 chains
- "Refactor the event pipeline, containment module, and health monitoring" → 3 agents, parallel

**System 2: Subagents (for single-feature work, reviews, and research)**

Subagents are individual Claude instances spawned for a specific task. They get a clean context, do one job, return the result, and terminate. The main session stays clean — no context pollution from the subagent's work.

Two patterns for subagents:

Pattern A — Subagent-Driven Development (superpowers plugin):
Used for single-feature work with multiple tasks. The main session acts as coordinator. It spawns one fresh subagent per task, feeds it the exact context it needs (not the full session history), and runs two-stage review after each: spec compliance first, then code quality.

- Fresh context per task (no accumulated confusion)
- Two-stage review (spec compliance → code quality) catches both "did it build the right thing" and "did it build it well"
- Coordinator preserves its context for orchestration
- If a subagent fails, dispatch a fix subagent — don't pollute the main context with debugging

When to use subagent-driven-dev:
- Single feature with 3+ implementation tasks
- Work that needs review between each step
- When you want quality gates but don't need the full 5-agent team

How to invoke: "Use subagent-driven-development for this."

Pattern B — Parallel Research/Review Subagents:
Spawn multiple subagents simultaneously for different aspects of the same problem. Each investigates independently and returns findings. The main session synthesizes.

Examples already built into your plugins:
- code-review plugin: Spawns 5 parallel Sonnet agents (CLAUDE.md compliance, bug scan, git history, previous PR comments, code comments) + Haiku confidence scorers
- pr-review-toolkit: 6 specialized agents (comments, tests, silent failures, types, quality, simplification)
- superpowers:brainstorming: Spawns spec-reviewer subagent to validate design before implementation

When to use parallel review subagents:
- Code review before merge
- Investigating a problem from multiple angles
- Research tasks where multiple sources need analysis
- Any situation where "get 3 opinions at once" is faster than "get 3 opinions sequentially"

How to invoke: "Dispatch parallel subagents to review/research/analyze X from these angles: [A, B, C]."

**System 3: MCP Ecosystem Agents (persistent specialists with memory)**

These are your custom-built agents from the Claude MCP Ecosystem plugin. Unlike subagents (which die after one task) and agent team members (which live for one session), these agents persist across sessions with memory files. They know your project.

Layer 0 — project-guide (invisible router): Fires when you ask about project organization or agent management. Detects ecosystem state, routes to concierge (new setup) or companion (existing management).

Layer 1 — Orchestration:
- subagent-concierge: Initial agent deployment. Scans project → inference engine selects template → chains: architect → scaffolder + memory-seeder (parallel) → validator.
- subagent-companion: Day-to-day management. Status, add, remove, diagnose, repair. Runs 4-check silent preflight before every operation.

Layer 2 — Pipeline workers (invoked by Layer 1 only):
- architect: Analyzes project, designs agent roster spec
- scaffolder + memory-seeder: Run in PARALLEL — scaffolder creates agent files and routing while memory-seeder populates MEMORY.md from project sources
- validator: Structural quality gate in isolated worktree
- auditor: Health diagnostics (memory bloat, drift, routing gaps)

When to use MCP Ecosystem agents:
- Setting up a new project's agent infrastructure (/agent-setup)
- Adding specialists to an existing project (/agent-add)
- Diagnosing agent issues (/agent-diagnose)
- Any time you need agents that remember context across sessions

How to invoke: /agent-setup, /agent-status, /agent-add, /agent-diagnose, /agent-reset

#### How the three systems compose together

They are not competing alternatives — they are layers that work together:

1. MCP Ecosystem sets up the project's agent infrastructure (Phase 0, once)
2. Agent Teams runs the development pipeline with parallel feature chains (Phase 2, per build)
3. Subagents handle individual tasks within each system (reviews, research, debugging)

The Agent Teams' Feature Agents can dispatch subagents for debugging. The MCP Ecosystem's concierge uses parallel subagents (scaffolder + memory-seeder). The code-review plugin spawns parallel review subagents after Agent Teams' pipeline completes. Each system amplifies the others.

#### Execution decision framework (mandatory)

Before starting any implementation work, evaluate the task against this framework. Always choose the most parallel option:

Complexity: 2+ independent features or components?
  → YES: Agent Teams. Spawn the full team. One Feature Agent per component. Parallel chains.
  → NO: Continue ↓

Complexity: Single feature with 3+ implementation tasks?
  → YES: Subagent-driven-development. One subagent per task, two-stage review.
  → NO: Continue ↓

Complexity: Single task, simple and clear?
  → YES: Direct implementation in main context. No agent overhead needed.

Task type: Code review or quality check?
  → Dispatch parallel review subagents (code-review plugin or pr-review-toolkit).

Task type: Research, investigation, or multi-angle analysis?
  → Dispatch parallel research subagents with different focus areas.

Task type: Debugging a hard problem?
  → superpowers:systematic-debugging in a subagent (isolate from main context).

Task type: Need persistent project-aware agents?
  → MCP Ecosystem (/agent-setup, /agent-add).

**The default is always parallel.** If you catch yourself implementing Feature B after Feature A when they are independent, you have made the wrong choice. Stop. Spawn the team. Run them in parallel.

#### Model selection for agent efficiency

Not every agent needs the most expensive model. Use the least powerful model that can handle the role:

| Agent Role | Recommended Model | Why |
|---|---|---|
| Team Lead | Inherit (Opus) | Needs judgment for orchestration |
| Feature Agent (simple, 1-2 files) | Sonnet | Mechanical implementation with clear spec |
| Feature Agent (complex, multi-file) | Opus | Needs architectural judgment |
| Quality Agent | Haiku | Runs tests and checks coverage — mechanical |
| Security Agent | Haiku | Pattern matching against known vulnerabilities |
| Code Review Agent | Sonnet | Needs code comprehension but not creativity |
| Merger Agent | Haiku | Git operations only — purely mechanical |
| Spec reviewer subagent | Sonnet | Needs to evaluate design quality |
| Research subagent | Sonnet | Needs comprehension and synthesis |
| Debugging subagent | Opus | Hardest task — needs deep reasoning |

This keeps costs down while maintaining quality where it matters. Cheap models for mechanical work, expensive models for judgment calls.

### Phase 3 — Quality Gates (built into agent-teams)

Phase 3 is embedded in the pipeline — Steps 4, 6, 7, 8, 9 ARE the quality gates:

- **Step 4 (RED verify):** Quality Agent independently runs tests, confirms all new tests fail before implementation begins.
- **Step 6 (GREEN verify):** Quality Agent independently runs full suite, confirms all pass, checks coverage ≥90% overall, no module below 80%.
- **Step 7 (Validate):** Feature Agent runs linter + type checker + full test suite.
- **Step 8 (Code Review):** Code Review Agent blocks on Critical/High issues. Feature Agent must fix and re-request.
- **Step 9 (Security):** Security Agent blocks on Critical/High findings. Feature Agent must fix and re-request.

**Additional review (optional, for critical PRs):** After the pipeline completes, you can manually invoke:
- **pr-review-toolkit** — 6 specialized parallel agents: comment-analyzer, pr-test-analyzer, silent-failure-hunter, type-design-analyzer, code-simplifier
- **code-review plugin** — 5 parallel agents with confidence scoring (issues ≥80 only)

These are supplements to agent-teams, not replacements. Use them for high-stakes merges.

### Phase 4 — Ship

10. Pipeline Step 10 handles branch + PR creation via Merger Agent.
11. `/commit-push-pr` — Alternative for simple changes not running the full pipeline.
12. **superpowers:finishing-a-development-branch** — For manual branch management: four options (merge, push PR, keep, discard). Verifies tests on merged result.
13. `/clean-gone` — Clean stale local branches and worktrees.

Done when: PR created (by Merger Agent or manually), worktree cleaned.

### Phase 5 — Session Close

14. `/wrap` — Log work, record decisions, update tasks/todo.md with handoff, append to session-log.md.
15. `/revise-claude-md` — Capture session learnings into project CLAUDE.md.

---

## Agent Infrastructure

### Agent-Teams — Development Pipeline

The primary build engine. 5 permanent agents + N feature agents enforce a strict TDD pipeline with task dependency chains. See Phase 2 above for the full pipeline.

**Spawning:** Team Lead reads `_project_specs/features/*.md`, spawns one Feature Agent per feature, creates the 10-task dependency chain for each, assigns spec-writing tasks.

**Communication:** Feature Agents message Quality/Review/Security agents when ready. Task List is the source of truth. Broadcast is rare (blocking cross-feature dependencies only).

**Quality gates via task dependencies:** A Feature Agent structurally cannot start Step N+1 until Step N is complete and verified. The Quality Agent, Code Review Agent, and Security Agent independently verify — they never trust another agent's report.

### MCP Ecosystem — Agent Lifecycle Management

Manages the specialist agent ecosystem around the development pipeline.

**Layer 0 — project-guide** (invisible router): Detects ecosystem state, routes to concierge (setup) or companion (management).

**Layer 1 — Orchestration:**
- **subagent-concierge** — Initial ecosystem setup. Scans project → selects template → chains: architect → scaffolder + memory-seeder (parallel) → validator.
- **subagent-companion** — Day-to-day management. Status, add, remove, diagnose, repair.

**Layer 2 — Pipeline Workers** (invoked by Layer 1 only):

| Agent | Role | Model |
|-------|------|-------|
| architect | Analyze project, design agent roster | inherit |
| scaffolder | Create agent files, memory dirs, routing | sonnet |
| memory-seeder | Populate MEMORY.md from project sources | sonnet |
| validator | Structural quality gate, isolated worktree | haiku |
| auditor | Health diagnostics (memory bloat, drift, gaps) | haiku |

### Code Factory — Extension Generation

35 skills for building Claude Code extensions from natural language.

**Core generators:** skill-factory, hook-factory, agent-factory, plugin-packager, settings-architect, mcp-configurator, output-style-creator, cicd-generator

**Intelligence layer:** extension-guide, extension-concierge, intent-engine, smart-scaffold

**Reference skills:** cc-ref-hooks, cc-ref-skills, cc-ref-settings, cc-ref-subagents, cc-ref-plugins, cc-ref-permissions, cc-ref-mcp, cc-ref-agent-archetypes, cc-ref-agent-workflows, cc-ref-multi-agent, cc-ref-output-styles, cc-ref-cicd

**Quality:** extension-auditor, extension-fixer, extension-validator, extension-combo-engine

**Dev Team Factory:** dev-team-guide, dev-team-concierge, team-combo-engine, team-configurator, team-architect

**10 specialist subagents:** system-architect, stack-analyzer, recommendation-engine, hook-engineer, plugin-builder, subagent-generator, extension-validator, doc-sync-checker, agent-quality-reviewer, team-architect

---

## Workflow Rules

### Autonomy Decision Tree

```
Bug fix with clear error/stack trace?
  → YES: Act autonomously. Fix it. Report what you did.

Feature, refactor, or architectural change?
  → YES: /plan → present to user → wait for confirmation.

Minor cleanup (formatting, typo, dead code)?
  → YES: Act autonomously. Mention in summary.

Failure is ambiguous (no clear root cause)?
  → YES: Investigate first. Present findings. Wait for confirmation.

Default → Ask.
```

### Learn From Corrections

After ANY correction, immediately update `tasks/lessons.md` with what went wrong and the actionable rule. Review lessons at every session start. Non-negotiable.

### Rollback Protocol

1. **Unrelated test break**: Stop. `git stash` or `git checkout -- .`. Re-plan.
2. **Your change broke build**: Revert and fix.
3. **Unexpected side effects**: Revert to last known good. Re-plan smaller.
4. **Partial completion**: Commit working code to branch, update todo.md, leave handoff note.

**Never leave main broken. Never push broken code.**

### Context Window Management

- Checkpoint to `tasks/todo.md` after each major step
- If context is long, write Session Handoff section proactively
- If task exceeds 10 steps or 5 files, propose splitting

### Context Compaction

When context usage exceeds 50%, proactively run /compact before continuing work. Preserve: current task state, active plan steps, file paths being worked on, and any error context. Discard: completed steps, exploratory reads, resolved debugging traces. Never wait for auto-compact to trigger — compact manually at logical breakpoints between steps.

---

## Phase Gate Enforcement

- Do not write code before Phase 1 plan is approved
- Do not skip any step in the agent-teams pipeline (task dependencies enforce this)
- Do not merge without pipeline completion (Quality + Review + Security all passed)
- Do not close session without `/wrap`
- If a gate seems wrong for the task, say so — don't silently skip

### Small Tasks Exception

Trivial changes (single-line fix, config tweak, typo): skip Phase 1 brainstorming and Phase 2 agent-teams pipeline. Use `/plan` → direct implementation → Phase 3 manual verification → `/commit`. If it takes more than 5 minutes, it's not trivial.

### Execution Mode Quick Reference

| Situation | Mode | Agents Involved |
|---|---|---|
| 2+ features to build | Agent Teams (parallel chains) | Team Lead + Quality + Security + Review + Merger + N Feature Agents |
| Full app from scratch | Agent Teams (parallel chains) | All — one Feature Agent per major component |
| Single feature, 3+ tasks | Subagent-driven-dev | Main context as coordinator + task subagents + review subagents |
| Code review before merge | Parallel review subagents | 5-6 specialized reviewers running simultaneously |
| Refactor 3+ modules | Agent Teams (parallel chains) | One Feature Agent per module |
| Bug fix, clear root cause | Direct mode | No agents — fix, verify, commit |
| Config change, typo | Direct mode | No agents — just do it |
| Hard debugging problem | Debugging subagent | Isolated subagent using systematic-debugging |
| Research or investigation | Parallel research subagents | 2-3 subagents with different focus areas |
| Need persistent specialists | MCP Ecosystem | /agent-setup → architect → scaffolder + memory-seeder → validator |

The default is ALWAYS the most parallel option. If in doubt, spawn the team.

---

## Code Standards

- **Simplicity**: Make every change as simple as possible. Touch minimal code.
- **Root Causes**: Find and fix root causes. No temporary fixes.
- **Minimal Blast Radius**: Only touch what is necessary.
- **Consistency**: Follow existing patterns. No new patterns without justification.
- **No Silent Failures**: Every error path handled explicitly.
- **No Orphaned Code**: No dead code, unused imports, or commented-out blocks.

### Coverage Standards
- Overall project coverage must be ≥90% before any handoff, push to remote, or DevOps delivery.
- No individual module may fall below 80% coverage. Security-critical modules (containment, auth, secrets handling) must be ≥95%.
- When running coverage, always check per-module results — not just the overall average. If any module is below threshold, write tests to bring it up before committing.
- Priority order for coverage gaps: security-critical first, then operational modules (health, monitoring, pipeline), then everything else.
- Coverage is not optional. Do not ask whether to write tests. Write them.

### Documentation Standards
Every project must have three living documents that are updated on every commit:
1. **CLAUDE.md** — Project governance, architecture, commands, conventions, test count, coverage.
2. **README.md** — Public-facing: what it does, how to install, how to run, file structure, status, author.
3. **docs/DEVOPS-HANDOFF.md** — DevOps delivery: project summary, environment requirements, how to run, configuration reference, security notes, deployment maturity, known tech debt.

If any of these are missing when you start a session, create them before doing any other work. If any are stale when you commit, update them. This is enforced by hooks but do not rely on hooks alone — treat it as a personal responsibility.

---

## Git Workflow

- Branch for every task: `feat/`, `fix/`, or `chore/`
- Never commit directly to main
- One logical change per commit
- Clear imperative commit messages
- Review your own diff before committing
- Run full test suite before pushing
- Merger Agent handles branch + PR in pipeline mode; `/commit-push-pr` in direct mode

---

## Do Not Touch List

Never modify without explicit user approval:
- Production configs, deployment configs
- Migration files already run
- CI/CD pipeline configs
- Lock files (except when adding approved dependencies)
- Secrets, API keys, credentials

---

## File Structure Convention

```
_project_specs/          # Feature specifications (committed)
├── features/            # One .md per feature with acceptance criteria + test cases
tasks/                   # Task tracking (committed)
├── todo.md              # Current plan with checkable items
├── lessons.md           # Rules from past corrections
context/                 # Operator identity (gitignored)
├── role.md, org.md, priorities.md, metrics.md
state/                   # Session audit trail (gitignored)
├── session-log.md       # Chronological log
├── decisions.md         # Design decision records
.claude/
├── agents/              # Agent definitions (team-lead, quality, security, etc.)
├── skills/              # Project-scoped skills
plans/                   # Implementation plans (gitignored)
outputs/                 # Work products (gitignored)
decisions/               # ADRs (committed)
```

Context and state files are private — never commit, never echo contents.

---

## Rule Authority

When rules conflict:

1. **This file** (global CLAUDE.md) — highest authority
2. **Project CLAUDE.md** — refines and extends, can override for project-specific needs
3. **tasks/lessons.md** — additive refinements from corrections

If ambiguous: follow existing patterns. If still unclear: simplest option, flag assumption.

---

## Reference Imports

Load on-demand when relevant:

- CLI commands: @context/cli-reference.md
- Creating skills: @context/skill-creation-guide.md
- MCP server setup: @context/mcp-setup-guide.md
- Subagent creation: @context/subagent-guide.md
- Hooks configuration: @context/hooks-guide.md
- Settings reference: @context/settings-reference.md

---

## Installed Plugin Inventory

Last updated: [DATE]

### Core Infrastructure (always active)

| Plugin | Role |
|--------|------|
| **agent-teams** (agentskill.sh) | Phase 2-3 engine: 5+N agent TDD pipeline with task dependency enforcement |
| **claude-mcp-ecosystem** v2.0.0 | OS: session commands, agent 3-layer routing, workspace governance |
| **claude-code-factory** v1.0.0 | Extension generation: 35 skills, 10 subagents, reference library |
| **superpowers** v5.0.5 | Phase 1 planning (brainstorming, writing-plans) + debugging utility |

### Bootstrap & Configuration (Phase 0)

| Plugin | Role |
|--------|------|
| claude-code-setup | Codebase analysis → automation recommendations |
| claude-md-management | CLAUDE.md audit, scoring, session learning capture |
| hookify | Project-specific hook rule authoring |
| security-guidance | Passive security warnings on file edits |

### Language & Stack (Phase 2, passive)

| Plugin | Role |
|--------|------|
| pyright-lsp | Python type checking |
| frontend-design | Frontend UI/UX guidance |

### Supplemental Review (Phase 3, optional)

| Plugin | Role |
|--------|------|
| code-review | Multi-agent PR review with confidence scoring |
| pr-review-toolkit | 6 specialized review agents |

### Ship (Phase 4)

| Plugin | Role |
|--------|------|
| commit-commands | /commit, /commit-push-pr, /clean-gone |

### Utilities (any phase)

| Plugin | Role |
|--------|------|
| github | GitHub MCP integration |
| slack | Slack workspace integration |
| learn | Skill discovery from agentskill.sh |
| plugin-dev | Plugin structure toolkit |
| claude-code-research | CC reference documentation |
| agent-sdk-dev | Claude Agent SDK reference documentation |
| explanatory-output-style | Educational insights on implementation choices |
| ralph-loop | Continuous self-referential development loops |

---

## tasks/lessons.md Template

```markdown
# Lessons

## Active Rules

### Seed Rules
- [Date] [Config]: Never modify shared config files without checking downstream consumers.
- [Date] [Scope]: If a "quick fix" requires 3+ files, it is not quick. Re-plan.
- [Date] [Testing]: Run the full test suite, not just tests for the changed module.
- [Date] [Dependencies]: Never add dependencies without explicit user approval.
- [Date] [Data]: Never delete production data, migrations, or seed data without approval.

### Learned Rules
<!-- Added during sessions when corrections occur -->

## Archived
<!-- Rules that no longer apply -->
```
