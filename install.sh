#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

KICKSTART_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${BLUE}Claude Code Kickstart Installer${NC}"
echo "================================"
echo ""

# 1. Check prerequisites
check_prereq() {
  if ! command -v "$1" &>/dev/null; then
    echo -e "${RED}ERROR: $1 is not installed.${NC}"
    exit 1
  fi
}
check_prereq claude
check_prereq python3
check_prereq git

# Verify running from repo
if [ ! -d "$KICKSTART_DIR/plugins" ]; then
  echo -e "${RED}ERROR: Run this script from the cloned claude-code-kickstart directory.${NC}"
  exit 1
fi

echo -e "${GREEN}Prerequisites OK${NC}"
echo ""

# 2. Backup existing files
TIMESTAMP=$(date +%Y%m%d%H%M)
if [ -f ~/.claude/CLAUDE.md ]; then
  cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$TIMESTAMP
  echo "Backed up ~/.claude/CLAUDE.md"
fi
if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.backup.$TIMESTAMP
  echo "Backed up ~/.claude/settings.json"
fi

# 3. Prompt for user info
echo ""
echo -e "${BLUE}Personalization${NC}"
read -p "Your full name: " USER_NAME
read -p "GitHub username: " GITHUB_USERNAME
read -p "Email (optional, press Enter to skip): " USER_EMAIL
read -p "Organization name (optional, press Enter to skip): " ORG_NAME

[ -z "$USER_EMAIL" ] && USER_EMAIL="[YOUR EMAIL]"
[ -z "$ORG_NAME" ] && ORG_NAME="[YOUR ORG]"

# 4. Copy and personalize global CLAUDE.md
mkdir -p ~/.claude
cp "$KICKSTART_DIR/templates/global/CLAUDE.md" ~/.claude/CLAUDE.md

# Detect OS for sed
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_CMD=(sed -i '')
else
  SED_CMD=(sed -i)
fi

"${SED_CMD[@]}" \
  -e "s/\[YOUR NAME\]/$USER_NAME/g" \
  -e "s/\[YOUR USERNAME\]/$USER_NAME/g" \
  -e "s/\[YOUR GITHUB USERNAME\]/$GITHUB_USERNAME/g" \
  -e "s/\[YOUR EMAIL\]/$USER_EMAIL/g" \
  -e "s/\[YOUR ORG\]/$ORG_NAME/g" \
  -e "s/\[YOUR PORTFOLIO URL\]/github.com\/$GITHUB_USERNAME/g" \
  -e "s/\[DATE\]/$(date +%Y-%m-%d)/g" \
  ~/.claude/CLAUDE.md

echo -e "${GREEN}Global CLAUDE.md installed${NC}"

# 5. Merge hooks into settings.json
if [ ! -f ~/.claude/settings.json ]; then
  echo '{}' > ~/.claude/settings.json
fi

python3 -c "
import json, sys

target_path = sys.argv[1]
source_path = sys.argv[2]
key = sys.argv[3]

with open(target_path) as f:
    settings = json.load(f)
with open(source_path) as f:
    new_data = json.load(f)

if key == 'hooks':
    existing = settings.get('hooks', {})
    for event, handlers in new_data.get('hooks', {}).items():
        if event in existing:
            existing[event].extend(handlers)
        else:
            existing[event] = handlers
    settings['hooks'] = existing
elif key == 'permissions':
    existing_allow = settings.get('permissions', {}).get('allow', [])
    new_allow = new_data.get('permissions', {}).get('allow', [])
    merged = list(dict.fromkeys(existing_allow + new_allow))
    settings.setdefault('permissions', {})['allow'] = merged

with open(target_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" ~/.claude/settings.json "$KICKSTART_DIR/templates/global/settings-hooks.json" hooks

echo -e "${GREEN}Hooks merged into settings.json${NC}"

# 6. Merge permissions
python3 -c "
import json, sys

target_path = sys.argv[1]
source_path = sys.argv[2]
key = sys.argv[3]

with open(target_path) as f:
    settings = json.load(f)
with open(source_path) as f:
    new_data = json.load(f)

if key == 'permissions':
    existing_allow = settings.get('permissions', {}).get('allow', [])
    new_allow = new_data.get('permissions', {}).get('allow', [])
    merged = list(dict.fromkeys(existing_allow + new_allow))
    settings.setdefault('permissions', {})['allow'] = merged

with open(target_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" ~/.claude/settings.json "$KICKSTART_DIR/templates/global/settings-permissions.json" permissions

echo -e "${GREEN}Permissions merged into settings.json${NC}"

# 7. Set environment variables
python3 -c "
import json

with open('$HOME/.claude/settings.json') as f:
    settings = json.load(f)

settings.setdefault('env', {})
settings['env']['CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS'] = '1'

with open('$HOME/.claude/settings.json', 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
"

echo -e "${GREEN}Environment variables set${NC}"

# 8. Copy context reference files
mkdir -p ~/.claude/context
cp "$KICKSTART_DIR/templates/context/"*.md ~/.claude/context/
echo -e "${GREEN}Context reference files installed ($(ls ~/.claude/context/*.md | wc -l | tr -d ' ') files)${NC}"

# 9. Set autocompact
SHELL_RC=""
if [ -f ~/.zshrc ]; then
  SHELL_RC=~/.zshrc
elif [ -f ~/.bashrc ]; then
  SHELL_RC=~/.bashrc
fi

if [ -n "$SHELL_RC" ]; then
  if ! grep -q "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE" "$SHELL_RC" 2>/dev/null; then
    echo 'export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50' >> "$SHELL_RC"
    echo -e "${GREEN}Autocompact configured in $SHELL_RC${NC}"
  else
    echo "Autocompact already configured"
  fi
fi

# 10. Register kickstart marketplace
python3 -c "
import json

with open('$HOME/.claude/settings.json') as f:
    settings = json.load(f)

settings.setdefault('extraKnownMarketplaces', {})
settings['extraKnownMarketplaces']['kickstart-local'] = {
    'source': {
        'source': 'directory',
        'path': '$KICKSTART_DIR'
    }
}

with open('$HOME/.claude/settings.json', 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
"

echo -e "${GREEN}Kickstart marketplace registered${NC}"

# 11-12. Install plugins
echo ""
echo -e "${BLUE}Installing plugins...${NC}"
bash "$KICKSTART_DIR/scripts/install-plugins.sh"

# 13. Health check
echo ""
bash "$KICKSTART_DIR/scripts/health-check.sh"

# 14. Summary
echo ""
echo -e "${GREEN}Claude Code Kickstart installed successfully!${NC}"
echo ""
echo "Quick Start:"
echo "  cd your-project"
echo "  claude"
echo ""
echo "Daily Workflow:"
echo "  /prime -> /plan -> /build -> /commit-push-pr -> /wrap"
echo ""
echo "New Project:"
echo "  bash $KICKSTART_DIR/scripts/scaffold-project.sh"
echo ""
echo "Docs:"
echo "  docs/getting-started.md    - First use tutorial"
echo "  docs/troubleshooting.md    - Common issues and fixes"
echo "  docs/customization.md      - How to customize"
echo ""
echo -e "${YELLOW}Restart Claude Code for changes to take effect.${NC}"
