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

5 test suites with 146 total assertions:

| Test | Assertions | What It Validates |
|------|-----------|-------------------|
| `tests/test_install.sh` | 37 | Installer logic: paths, sanitization, JSON merging, sed replacement |
| `tests/test_health_check.sh` | 25 | Health check against 3 mock environments (empty, full, partial) |
| `tests/test_scaffold.sh` | 19 | Scaffold: directories, templates, git initialization |
| `tests/test_install_plugins.sh` | 37 | Plugin script: names, community refs, local engines, error handling |
| `tests/test_integration.sh` | 28 | End-to-end: scaffold + verify structure, content, sanitization, idempotency |

Run all: `for f in tests/test_*.sh; do bash "$f"; done`

## Current Status

- **Version:** 1.0.0
- **Files:** 210
- **Tests:** 5 suites, 146 assertions
- **Last updated:** 2026-03-22
- **Docs:** README.md, docs/DEVOPS-HANDOFF.md, docs/architecture.md, docs/getting-started.md, docs/troubleshooting.md, docs/customization.md, docs/user-guide.md, docs/command-reference.md
