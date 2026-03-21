# DevOps Handoff — Claude Code Kickstart

**Last Updated:** 2026-03-21
**Author:** [YOUR NAME]
**Status:** Production-Ready

## Project Summary

Open-source governance framework that installs hooks, plugins, templates, and documentation into a Claude Code environment. Not a running application — a distribution of configuration files.

## Current State

- **Version:** 1.0.0
- **Branch:** main
- **Files:** 194
- **Known issues:** 0

## Environment Requirements

| Requirement | Version | Notes |
|-------------|---------|-------|
| Claude Code | Latest | Must be installed and in PATH |
| Python 3 | 3.10+ | Used for JSON merging during install |
| Git | Any | Required for repo operations |
| Bash | 4+ | Scripts use bash features |

## How to Run

### Install
```bash
git clone https://github.com/[YOUR GITHUB USERNAME]/claude-code-kickstart.git
cd claude-code-kickstart
./install.sh
```

### Verify
```bash
bash scripts/health-check.sh
```

### Scaffold New Project
```bash
mkdir ~/new-project && cd ~/new-project
bash ~/path/to/claude-code-kickstart/scripts/scaffold-project.sh
```

## Configuration Reference

| Config | Location | Purpose |
|--------|----------|---------|
| Global CLAUDE.md | `~/.claude/CLAUDE.md` | Governance framework |
| settings.json | `~/.claude/settings.json` | Hooks, permissions, env vars |
| Context files | `~/.claude/context/*.md` | Reference documentation |

## Security Notes

- No secrets stored in the repo
- All personal data sanitized with placeholders
- Install script backs up existing files before overwriting
- Secrets scanning hook prevents accidental credential commits

## Deployment Maturity

| Aspect | Status |
|--------|--------|
| Installation script | Complete |
| Health check validation | Complete |
| Documentation | Complete |
| CI/CD pipeline | Not applicable |

## Contact

- **Author:** [YOUR NAME]
- **Email:** [YOUR EMAIL]
