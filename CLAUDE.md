# Claude Code Kickstart

> Open-source governance framework for Claude Code vibecoders.

## Architecture

Monorepo packaging two plugin engines, hooks, templates, scripts, and documentation.

```
claude-code-kickstart/
├── plugins/
│   ├── claude-mcp-ecosystem/    # Session commands + agent lifecycle
│   └── claude-code-factory/     # Extension generation + reference library
├── templates/
│   ├── global/                  # CLAUDE.md, settings hooks/permissions
│   ├── context/                 # 6 reference documents
│   └── project/                 # Per-project starters
├── docs/                        # User documentation
├── scripts/                     # Install + utility scripts
└── install.sh                   # One-line installer
```

## Commands

This is a distribution repo — not an application. No test suite, no build step.

- `./install.sh` — Install the framework
- `bash scripts/scaffold-project.sh` — Create a new project
- `bash scripts/health-check.sh` — Verify installation

## Conventions

- All files sanitized (no personal data)
- Placeholders: `[YOUR NAME]`, `[YOUR USERNAME]`, `[YOUR ORG]`, etc.
- Scripts use portable bash (macOS + Linux compatible)

## Testing

No automated tests — this is a configuration/documentation distribution.
Validation via `scripts/health-check.sh` after install.

## Current Status

- **Version:** 1.0.0
- **Files:** ~198
- **Last updated:** 2026-03-21
- **Docs:** README.md, docs/DEVOPS-HANDOFF.md, docs/architecture.md, docs/getting-started.md, docs/troubleshooting.md, docs/customization.md
