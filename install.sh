#!/usr/bin/env bash
# AI Personal Finance Advisor (German Edition) - Installer
# Repo: phrankson/claude--finance
#
# Local install:  ./install.sh
# Remote install: curl -fsSL https://raw.githubusercontent.com/phrankson/claude--finance/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

REPO="phrankson/claude--finance"
BRANCH="main"
TARBALL_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
AGENTS_DIR="${CLAUDE_DIR}/agents"
VENV_DIR="${SKILLS_DIR}/finance/venv"

# Detect local vs remote install
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
IS_LOCAL=0
SOURCE_DIR=""

if [ -n "$SCRIPT_PATH" ] && [ -f "$SCRIPT_PATH" ]; then
  SOURCE_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
  if [ -d "${SOURCE_DIR}/skills" ] && [ -d "${SOURCE_DIR}/finance" ]; then
    IS_LOCAL=1
  fi
fi

print_banner() {
  echo ""
  echo -e "${BOLD}${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${YELLOW}║                                                          ║${NC}"
  echo -e "${BOLD}${YELLOW}║    AI PERSONAL FINANCE ADVISOR — German Edition          ║${NC}"
  echo -e "${BOLD}${YELLOW}║    GKV/PKV · bAV · GRV · UCITS ETFs · Abgeltungsteuer  ║${NC}"
  echo -e "${BOLD}${YELLOW}║                                                          ║${NC}"
  echo -e "${BOLD}${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

err() {
  echo -e "${RED}✗ $1${NC}" >&2
}

ok() {
  echo -e "${GREEN}✓${NC} $1"
}

info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

check_python() {
  if ! command -v python3 >/dev/null 2>&1; then
    err "Python 3 not found. Install with: brew install python3"
    return 1
  fi

  local pyver
  pyver=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
  local major minor
  major=$(echo "$pyver" | cut -d. -f1)
  minor=$(echo "$pyver" | cut -d. -f2)

  if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -lt 8 ]; }; then
    err "Python 3.8+ required (found ${pyver})."
    return 1
  fi

  ok "Python ${pyver} detected"
  return 0
}

setup_reportlab_venv() {
  # macOS Homebrew Python (and many Linux distros) block system-wide pip (PEP 668).
  # Install reportlab into an isolated venv instead of the system Python.
  local venv="${VENV_DIR}"

  # Check if reportlab already available in venv
  if [ -f "${venv}/bin/python3" ] && "${venv}/bin/python3" -c "import reportlab" >/dev/null 2>&1; then
    local rlver
    rlver=$("${venv}/bin/python3" -c "import reportlab; print(reportlab.Version)")
    ok "ReportLab ${rlver} ready (venv)"
    return 0
  fi

  # Check if reportlab already available in system Python (fallback)
  if python3 -c "import reportlab" >/dev/null 2>&1; then
    local rlver
    rlver=$(python3 -c "import reportlab; print(reportlab.Version)")
    ok "ReportLab ${rlver} detected (system Python)"
    return 0
  fi

  info "Creating Python venv for ReportLab at ${venv}..."
  mkdir -p "$(dirname "${venv}")"
  if ! python3 -m venv "${venv}" 2>/dev/null; then
    warn "Could not create venv. Install manually: python3 -m venv ${venv} && ${venv}/bin/pip install reportlab"
    return 0
  fi

  info "Installing ReportLab into venv..."
  if "${venv}/bin/pip" install --quiet "reportlab>=4.0.0" 2>/dev/null; then
    local rlver
    rlver=$("${venv}/bin/python3" -c "import reportlab; print(reportlab.Version)")
    ok "ReportLab ${rlver} installed → ${venv}"
  else
    warn "ReportLab install failed. PDF reports will not work."
    warn "Fix manually: ${venv}/bin/pip install reportlab"
  fi
}

fetch_remote() {
  info "Downloading repo tarball..."
  local tmp
  tmp=$(mktemp -d)
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$TARBALL_URL" | tar -xz -C "$tmp"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$TARBALL_URL" | tar -xz -C "$tmp"
  else
    err "Neither curl nor wget found."
    exit 1
  fi
  # GitHub archive extracts as: claude--finance-main/
  SOURCE_DIR="${tmp}/claude--finance-${BRANCH}"
  if [ ! -d "$SOURCE_DIR" ]; then
    err "Tarball extraction failed: ${SOURCE_DIR} not found."
    exit 1
  fi
  ok "Repo downloaded to ${SOURCE_DIR}"
}

install_orchestrator() {
  local src="${SOURCE_DIR}/finance"
  if [ ! -d "$src" ]; then
    warn "No orchestrator folder at ${src}, skipping."
    return
  fi
  mkdir -p "${SKILLS_DIR}/finance"
  cp -R "${src}/." "${SKILLS_DIR}/finance/"
  ok "Installed orchestrator → ~/.claude/skills/finance/"
}

install_skills() {
  local src="${SOURCE_DIR}/skills"
  if [ ! -d "$src" ]; then
    warn "No skills/ folder at ${src}, skipping."
    return
  fi
  local count=0
  for dir in "$src"/*/; do
    [ -d "$dir" ] || continue
    local name
    name=$(basename "$dir")
    mkdir -p "${SKILLS_DIR}/${name}"
    cp -R "${dir}." "${SKILLS_DIR}/${name}/"
    count=$((count + 1))
  done
  ok "Installed ${count} sub-skills → ~/.claude/skills/finance-*/"
}

install_agents() {
  local src="${SOURCE_DIR}/agents"
  if [ ! -d "$src" ]; then
    return
  fi
  mkdir -p "${AGENTS_DIR}"
  local count=0
  for file in "$src"/*.md; do
    [ -f "$file" ] || continue
    cp "$file" "${AGENTS_DIR}/"
    count=$((count + 1))
  done
  if [ "$count" -gt 0 ]; then
    ok "Installed ${count} agents → ~/.claude/agents/"
  fi
}

install_scripts() {
  local src="${SOURCE_DIR}/scripts"
  if [ ! -d "$src" ]; then
    warn "No scripts/ folder at ${src}, skipping."
    return
  fi
  mkdir -p "${SKILLS_DIR}/finance/scripts"
  cp -R "${src}/." "${SKILLS_DIR}/finance/scripts/"
  chmod +x "${SKILLS_DIR}/finance/scripts/"*.py 2>/dev/null || true
  ok "Installed scripts → ~/.claude/skills/finance/scripts/"
}

print_summary() {
  local skill_count
  skill_count=$(find "${SKILLS_DIR}" -maxdepth 1 -type d -name "finance*" 2>/dev/null | wc -l | tr -d ' ')

  echo ""
  echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${GREEN}║              INSTALLATION COMPLETE                       ║${NC}"
  echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${BOLD}Installed:${NC}"
  echo -e "  ${GREEN}•${NC} ${skill_count} skill folder(s) under ~/.claude/skills/"
  echo -e "  ${GREEN}•${NC} ReportLab venv at ~/.claude/skills/finance/venv/"
  echo ""
  echo -e "${BOLD}${CYAN}Command Reference:${NC}"
  echo -e "  ${MAGENTA}/finance${NC}             — Main orchestrator (routing + PDF)"
  echo -e "  ${MAGENTA}/finance quick${NC}       — 60-second financial snapshot"
  echo -e "  ${MAGENTA}/finance analyze${NC}     — Full multi-agent analysis (5 parallel)"
  echo -e "  ${MAGENTA}/finance insurance${NC}   — GKV vs PKV · BU gap · Haftpflicht check"
  echo -e "  ${MAGENTA}/finance budget${NC}      — Cash flow & budget analysis"
  echo -e "  ${MAGENTA}/finance debt${NC}        — Debt payoff strategy (Dispo first)"
  echo -e "  ${MAGENTA}/finance emergency${NC}   — Notgroschen target & plan"
  echo -e "  ${MAGENTA}/finance portfolio${NC}   — UCITS ETF allocation review"
  echo -e "  ${MAGENTA}/finance retirement${NC}  — GRV + bAV + Depot projections"
  echo -e "  ${MAGENTA}/finance fire${NC}        — FIRE calculator (33× rule, Abgeltungsteuer)"
  echo -e "  ${MAGENTA}/finance taxes${NC}       — bAV · Rürup · Sparerpauschbetrag optimization"
  echo -e "  ${MAGENTA}/finance networth${NC}    — Net worth tracker"
  echo -e "  ${MAGENTA}/finance goals${NC}       — Goal-based savings plans"
  echo -e "  ${MAGENTA}/finance compare${NC}     — Kauf vs Miete · bAV vs ETF · scenarios"
  echo -e "  ${MAGENTA}/finance screen${NC}      — ETF screener (UCITS only)"
  echo -e "  ${MAGENTA}/finance report-pdf${NC}  — Generate client-ready PDF"
  echo ""
  echo -e "${BOLD}${CYAN}Advisor guide:${NC} see ${BLUE}docs/DE-BERATER-GUIDE.md${NC} in the repo"
  echo ""
  echo -e "${BOLD}${CYAN}Quick start:${NC} open Claude Code and type ${MAGENTA}/finance quick${NC}"
  echo ""
  echo -e "${YELLOW}⚠  Kein Ersatz für Finanz-, Steuer- oder Versicherungsberatung.${NC}"
  echo -e "${YELLOW}⚠  Not financial advice. Consult a licensed advisor.${NC}"
  echo ""
}

main() {
  print_banner

  info "Detecting environment..."
  if [ "$IS_LOCAL" -eq 1 ]; then
    ok "Local install detected (source: ${SOURCE_DIR})"
  else
    info "Remote install (curl | bash) detected"
    fetch_remote
  fi

  echo ""
  info "Checking prerequisites..."
  check_python || exit 1

  echo ""
  info "Creating Claude directories..."
  mkdir -p "${SKILLS_DIR}" "${AGENTS_DIR}"
  ok "~/.claude/skills/ and ~/.claude/agents/ ready"

  echo ""
  info "Installing components..."
  install_orchestrator
  install_skills
  install_agents
  install_scripts

  echo ""
  info "Setting up Python environment for PDF reports..."
  setup_reportlab_venv

  print_summary
}

main "$@"
