#!/usr/bin/env bash
# bump-version.sh — Synchronize version strings across all files listed in .version-bump.json
#
# Usage:
#   ./scripts/bump-version.sh <new-version>
#
# Example:
#   ./scripts/bump-version.sh 0.3.0
#
# Files updated are read from .version-bump.json "files" array.
# Each file must contain a line matching:  "version": "<current>"
# That line is replaced with:             "version": "<new-version>"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VERSION_BUMP_FILE="${REPO_ROOT}/.version-bump.json"

# ── Argument validation ────────────────────────────────────────────────────────

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <new-version>" >&2
  echo "Example: $0 0.3.0" >&2
  exit 1
fi

NEW_VERSION="$1"

# Basic semver format check (X.Y.Z — no pre-release or build metadata)
if ! [[ "${NEW_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be in X.Y.Z format (e.g. 0.3.0)" >&2
  exit 1
fi

# ── Read file list from .version-bump.json ─────────────────────────────────────

if [[ ! -f "${VERSION_BUMP_FILE}" ]]; then
  echo "Error: .version-bump.json not found at ${VERSION_BUMP_FILE}" >&2
  exit 1
fi

# Extract file paths from the "files" array using a POSIX-compatible sed approach.
# Reads lines between the first [ and the matching ] that contain quoted strings.
mapfile -t FILES < <(
  grep -oE '"[^"]+"' "${VERSION_BUMP_FILE}" \
  | grep -v '"files"' \
  | grep -v '"pattern"' \
  | tr -d '"'
)

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Error: no files found in .version-bump.json" >&2
  exit 1
fi

# ── Apply version bump ─────────────────────────────────────────────────────────

echo "Bumping version to ${NEW_VERSION} in:"

for RELATIVE_PATH in "${FILES[@]}"; do
  FILE="${REPO_ROOT}/${RELATIVE_PATH}"

  if [[ ! -f "${FILE}" ]]; then
    echo "  WARNING: ${RELATIVE_PATH} not found — skipping" >&2
    continue
  fi

  # Replace the first occurrence of "version": "..." on its own key line.
  # The sed expression is intentionally conservative — matches only
  # double-quoted version values, not version strings embedded in URLs.
  sed -i 's/"version": "[^"]*"/"version": "'"${NEW_VERSION}"'"/' "${FILE}"

  echo "  ${RELATIVE_PATH}"
done

echo ""
echo "Done. Verify with: grep -r '\"version\"' ${REPO_ROOT}/.version-bump.json $(IFS=' '; echo "${FILES[*]/#/${REPO_ROOT}/}")"
