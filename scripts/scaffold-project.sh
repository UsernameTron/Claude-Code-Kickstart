#!/bin/bash
# Create standard Claude Code project structure in current directory

KICKSTART_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Scaffolding Claude Code project structure..."

# Create directories
mkdir -p _project_specs/features
mkdir -p tasks
mkdir -p context
mkdir -p state
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p plans
mkdir -p outputs
mkdir -p decisions
mkdir -p docs

# Copy project templates
cp "$KICKSTART_DIR/templates/project/CLAUDE.md" ./CLAUDE.md
cp "$KICKSTART_DIR/templates/project/README.md" ./README.md
cp "$KICKSTART_DIR/templates/project/.gitignore" ./.gitignore
cp "$KICKSTART_DIR/templates/project/lessons.md" ./tasks/lessons.md
cp "$KICKSTART_DIR/templates/project/DEVOPS-HANDOFF.md" ./docs/DEVOPS-HANDOFF.md

# Copy decision template if available
if [ -f "$KICKSTART_DIR/plugins/claude-code-factory/decisions/_template.md" ]; then
  cp "$KICKSTART_DIR/plugins/claude-code-factory/decisions/_template.md" ./decisions/_template.md
fi

# Initialize git if not already
if [ ! -d .git ]; then
  git init && git branch -m main
  echo "  Git initialized on main branch"
fi

echo ""
echo "Project scaffolded. Open Claude Code and the SessionStart hook will detect everything."
echo "  Run: claude"
