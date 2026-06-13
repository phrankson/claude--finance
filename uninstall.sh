#!/usr/bin/env bash
# AI Personal Finance Advisor (German Edition) - Uninstaller
# Removes all finance skills, agents, and Python venv from ~/.claude/
# Usage: bash uninstall.sh [--yes|-y]   (--yes skips confirmation)

set -e

AUTO_YES=0
for arg in "$@"; do
  case "$arg" in
    -y|--yes) AUTO_YES=1 ;;
  esac
done

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
AGENTS_DIR="${CLAUDE_DIR}/agents"

echo ""
echo -e "${BOLD}${YELLOW}AI Personal Finance Advisor (German Edition) — Uninstaller${NC}"
echo "============================================================="
echo ""
echo -e "${YELLOW}This will remove the following from ~/.claude/:${NC}"
echo "  • skills/finance/        (orchestrator + scripts + venv)"
echo "  • skills/finance-*/      (all 15 sub-skills)"
echo "  • agents/finance-*.md"
echo ""

if [ "$AUTO_YES" -eq 1 ]; then
  REPLY="y"
elif [ -c /dev/tty ]; then
  read -p "Continue with uninstall? (y/N) " -n 1 -r < /dev/tty
  echo ""
else
  echo -e "${RED}No interactive terminal. Run: bash uninstall.sh --yes${NC}" >&2
  echo -e "${RED}Or via curl: curl -fsSL <url>/uninstall.sh | bash -s -- --yes${NC}" >&2
  exit 1
fi

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${BLUE}Uninstall cancelled.${NC}"
  exit 0
fi

removed_count=0

# Remove orchestrator (includes scripts/ and venv/)
if [ -d "${SKILLS_DIR}/finance" ]; then
  rm -rf "${SKILLS_DIR}/finance"
  echo -e "${GREEN}✓${NC} Removed skills/finance/ (includes venv and scripts)"
  removed_count=$((removed_count + 1))
fi

# Remove all finance-* sub-skills
if [ -d "${SKILLS_DIR}" ]; then
  for dir in "${SKILLS_DIR}"/finance-*; do
    if [ -d "$dir" ]; then
      name=$(basename "$dir")
      rm -rf "$dir"
      echo -e "${GREEN}✓${NC} Removed skills/${name}/"
      removed_count=$((removed_count + 1))
    fi
  done
fi

# Remove all finance-* agents
if [ -d "${AGENTS_DIR}" ]; then
  for file in "${AGENTS_DIR}"/finance-*.md; do
    if [ -f "$file" ]; then
      name=$(basename "$file")
      rm -f "$file"
      echo -e "${GREEN}✓${NC} Removed agents/${name}"
      removed_count=$((removed_count + 1))
    fi
  done
fi

echo ""
if [ "$removed_count" -eq 0 ]; then
  echo -e "${YELLOW}Nothing to remove. AI Personal Finance Advisor was not installed.${NC}"
else
  echo -e "${BOLD}${GREEN}Uninstall complete.${NC} Removed ${removed_count} item(s)."
fi
echo ""
