#!/usr/bin/env bash
# load-skill.sh — Inject a claude-skills SKILL.md as a system prompt for any CLI
#
# Usage:
#   ./scripts/load-skill.sh <skill-name>                  # print system prompt
#   ./scripts/load-skill.sh <skill-name> "<prompt>"       # run with codex/gemini
#   ./scripts/load-skill.sh --list                        # list available skills
#   ./scripts/load-skill.sh --combine "s1,s2" "<prompt>"  # merge multiple skills
#
# Examples:
#   ./scripts/load-skill.sh code-review
#   ./scripts/load-skill.sh code-review "Review src/auth.ts"
#   ./scripts/load-skill.sh --combine "code-review,security-audit" "Review PR #42"

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")/.." && pwd)/skills"

strip_frontmatter() {
  # Remove YAML frontmatter block (--- ... ---)
  local file="$1"
  awk '/^---$/{found++; next} found==1{next} found>=2{print}' "$file"
}

list_skills() {
  echo "Available skills:"
  for dir in "$SKILLS_DIR"/*/; do
    skill=$(basename "$dir")
    desc=$(grep -m1 '^description:' "$dir/SKILL.md" 2>/dev/null | sed 's/description: //' || echo "")
    printf "  %-28s %s\n" "$skill" "$desc"
  done
}

if [[ "${1:-}" == "--list" ]]; then
  list_skills
  exit 0
fi

if [[ "${1:-}" == "--combine" ]]; then
  skills_csv="${2:-}"
  user_prompt="${3:-}"
  combined=""
  IFS=',' read -ra skill_names <<< "$skills_csv"
  for skill in "${skill_names[@]}"; do
    skill_file="$SKILLS_DIR/$skill/SKILL.md"
    if [[ ! -f "$skill_file" ]]; then
      echo "ERROR: Skill '$skill' not found in $SKILLS_DIR" >&2
      exit 1
    fi
    combined+=$'\n\n'"$(strip_frontmatter "$skill_file")"
  done
  if [[ -z "$user_prompt" ]]; then
    echo "$combined"
  else
    # Detect which CLI to use based on available commands
    if command -v codex &>/dev/null; then
      codex --instructions "$combined" "$user_prompt"
    elif command -v gemini &>/dev/null; then
      gemini --system-prompt "$combined" "$user_prompt"
    else
      echo "System prompt:" >&2
      echo "$combined"
      echo "" >&2
      echo "No CLI detected. Install: npm i -g @openai/codex OR npm i -g @google/gemini-cli" >&2
    fi
  fi
  exit 0
fi

# Single skill mode
skill_name="${1:-}"
user_prompt="${2:-}"

if [[ -z "$skill_name" ]]; then
  echo "Usage: $0 <skill-name> [\"<prompt>\"]" >&2
  echo "       $0 --list" >&2
  echo "       $0 --combine \"skill1,skill2\" [\"<prompt>\"]" >&2
  exit 1
fi

skill_file="$SKILLS_DIR/$skill_name/SKILL.md"

if [[ ! -f "$skill_file" ]]; then
  echo "ERROR: Skill '$skill_name' not found." >&2
  echo "" >&2
  list_skills >&2
  exit 1
fi

system_prompt=$(strip_frontmatter "$skill_file")

if [[ -z "$user_prompt" ]]; then
  # Just print the system prompt (useful for piping)
  echo "$system_prompt"
  exit 0
fi

# Run with detected CLI
if command -v codex &>/dev/null; then
  codex --instructions "$system_prompt" "$user_prompt"
elif command -v gemini &>/dev/null; then
  gemini --system-prompt "$system_prompt" "$user_prompt"
else
  echo "System prompt (no CLI detected):" >&2
  echo "$system_prompt"
  echo "" >&2
  echo "Prompt: $user_prompt" >&2
  echo "Install: npm i -g @openai/codex OR npm i -g @google/gemini-cli" >&2
  exit 1
fi
