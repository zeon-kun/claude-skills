#!/usr/bin/env bash
# claude-skills installer
# Installs skills, agents, and commands globally (~/.claude/) or project-level (./.claude/)
#
# Usage:
#   ./install.sh                                   # install all skills + agents + commands globally
#   ./install.sh --project                         # install all to current project's .claude/
#   ./install.sh --skills-only                     # install only skills globally
#   ./install.sh --agents-only                     # install only agents globally
#   ./install.sh --commands-only                   # install only commands globally
#   ./install.sh --skills code-review debug        # install specific skills globally
#   ./install.sh --agents code-reviewer            # install specific agents globally
#   ./install.sh --commands review-pr dev-session  # install specific commands globally
#   ./install.sh --project --skills code-review --agents code-reviewer --commands review-pr

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
AGENTS_SRC="$SCRIPT_DIR/.claude/agents"
COMMANDS_SRC="$SCRIPT_DIR/.claude/commands"

# ── Parse flags ──────────────────────────────────────────────────────────────
PROJECT_MODE=false
INSTALL_SKILLS=true
INSTALL_AGENTS=true
INSTALL_COMMANDS=true
SELECTED_SKILLS=()
SELECTED_AGENTS=()
SELECTED_COMMANDS=()

i=0
args=("$@")
while [[ $i -lt ${#args[@]} ]]; do
  arg="${args[$i]}"
  case "$arg" in
    --project)      PROJECT_MODE=true ;;
    --skills-only)  INSTALL_AGENTS=false; INSTALL_COMMANDS=false ;;
    --agents-only)  INSTALL_SKILLS=false; INSTALL_COMMANDS=false ;;
    --commands-only) INSTALL_SKILLS=false; INSTALL_AGENTS=false ;;
    --skills)
      while [[ $((i+1)) -lt ${#args[@]} && "${args[$((i+1))]}" != --* ]]; do
        i=$((i+1)); SELECTED_SKILLS+=("${args[$i]}")
      done
      INSTALL_AGENTS=false; INSTALL_COMMANDS=false
      ;;
    --agents)
      while [[ $((i+1)) -lt ${#args[@]} && "${args[$((i+1))]}" != --* ]]; do
        i=$((i+1)); SELECTED_AGENTS+=("${args[$i]}")
      done
      INSTALL_SKILLS=false; INSTALL_COMMANDS=false
      ;;
    --commands)
      while [[ $((i+1)) -lt ${#args[@]} && "${args[$((i+1))]}" != --* ]]; do
        i=$((i+1)); SELECTED_COMMANDS+=("${args[$i]}")
      done
      INSTALL_SKILLS=false; INSTALL_AGENTS=false
      ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
  i=$((i+1))
done

# ── Determine target base ─────────────────────────────────────────────────────
if [[ "$PROJECT_MODE" == true ]]; then
  BASE_TARGET="$(pwd)/.claude"
  SCOPE="project ($(pwd)/.claude/)"
else
  BASE_TARGET="${HOME}/.claude"
  SCOPE="global (~/.claude/)"
fi

# ── Install helper ────────────────────────────────────────────────────────────
install_components() {
  local kind="$1"       # "skills" or "agents"
  local src_dir="$2"
  local target_dir="$3"
  local -n selected="$4"  # nameref to selected array

  if [[ ! -d "$src_dir" ]]; then
    echo "  [WARN] Source not found: $src_dir — skipping $kind"
    return
  fi

  mkdir -p "$target_dir"

  local to_install=()
  if [[ ${#selected[@]} -eq 0 ]]; then
    mapfile -t to_install < <(ls "$src_dir")
  else
    to_install=("${selected[@]}")
  fi

  echo "── $kind ──────────────────────────────────────"
  local installed=0 skipped=0 failed=0

  for name in "${to_install[@]}"; do
    local src="$src_dir/$name"
    local dst="$target_dir/$name"

    if [[ ! -e "$src" ]]; then
      echo "  SKIP   $name (not found)"
      ((skipped++)) || true; continue
    fi

    if [[ -e "$dst" ]]; then
      read -r -p "  $name already exists. Overwrite? [y/N] " confirm
      if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "  SKIP   $name"
        ((skipped++)) || true; continue
      fi
      rm -rf "$dst"
    fi

    if cp -r "$src" "$dst"; then
      echo "  OK     $name"
      ((installed++)) || true
    else
      echo "  FAIL   $name"
      ((failed++)) || true
    fi
  done

  echo "  → $installed installed, $skipped skipped, $failed failed"
  echo ""
}

# ── Run ───────────────────────────────────────────────────────────────────────
echo "claude-skills installer"
echo "  Scope: $SCOPE"
echo ""

[[ "$INSTALL_SKILLS" == true ]] && \
  install_components "skills" "$SKILLS_SRC" "$BASE_TARGET/skills" SELECTED_SKILLS

[[ "$INSTALL_AGENTS" == true ]] && \
  install_components "agents" "$AGENTS_SRC" "$BASE_TARGET/agents" SELECTED_AGENTS

[[ "$INSTALL_COMMANDS" == true ]] && \
  install_components "commands" "$COMMANDS_SRC" "$BASE_TARGET/commands" SELECTED_COMMANDS

# ── Summary ───────────────────────────────────────────────────────────────────
echo "Installation complete."
if [[ "$PROJECT_MODE" == false ]]; then
  echo ""
  echo "Skills:   invoke with /skill-name or Skill(skill=\"name\", args=\"...\")"
  echo "Agents:   invoke with Agent(subagent_type=\"name\", prompt=\"...\")"
  echo "          or via /agents to browse installed agents"
  echo "Commands: invoke with /command-name in any Claude Code session"
else
  echo ""
  echo "Installed to $(pwd)/.claude/"
  echo "Available in this project only."
fi
