#!/usr/bin/env bash
# format-python.sh — PostToolUse hook su Edit|Write.
#
# Formatta con ruff il file Python appena modificato. Non blocca mai:
# se ruff/uv non sono ancora installati (es. prima di M0) esce in silenzio.

set -uo pipefail

INPUT="$(cat)"

if command -v jq >/dev/null 2>&1; then
  FILE="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')"
elif command -v python3 >/dev/null 2>&1; then
  FILE="$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))')"
else
  exit 0
fi

case "$FILE" in
  *.py) ;;
  *) exit 0 ;;
esac

[ -f "$FILE" ] || exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[ -f pyproject.toml ] || exit 0

if command -v uv >/dev/null 2>&1; then
  uv run --quiet ruff format --quiet "$FILE" >/dev/null 2>&1 || true
  uv run --quiet ruff check --fix --quiet "$FILE" >/dev/null 2>&1 || true
elif command -v ruff >/dev/null 2>&1; then
  ruff format --quiet "$FILE" >/dev/null 2>&1 || true
  ruff check --fix --quiet "$FILE" >/dev/null 2>&1 || true
fi

exit 0
