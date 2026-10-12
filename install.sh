#!/usr/bin/env bash
# Install p3-stack skills for T3 Code.
#
#   ./install.sh                          link into ~/.agents/skills
#   ./install.sh --claude                 also link into ~/.claude/skills (Claude Code does not read .agents/skills)
#   ./install.sh --project /path/to/repo  link into the repo's .agents/skills (and .claude/skills with --claude)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$HOME"
CLAUDE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) BASE="${2:?usage: ./install.sh --project /path/to/repo}"; shift 2 ;;
    --claude) CLAUDE=1; shift ;;
    *) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
  esac
done

link_into() {
  local target="$1" installed=0 skipped=0 skill name
  mkdir -p "$target"
  for skill in "$ROOT"/skills/*/; do
    name="$(basename "$skill")"
    if [[ -L "$target/$name" ]]; then
      rm "$target/$name"
    elif [[ -e "$target/$name" ]]; then
      printf 'skip %s (exists and is not a symlink)\n' "$name"
      skipped=$((skipped + 1))
      continue
    fi
    ln -s "$skill" "$target/$name"
    installed=$((installed + 1))
  done

  printf 'linked %d skills into %s' "$installed" "$target"
  if [[ "$skipped" -gt 0 ]]; then
    printf ' (%d skipped)' "$skipped"
  fi
  printf '\n'
}

link_into "$BASE/.agents/skills"
if [[ "$CLAUDE" -eq 1 ]]; then
  link_into "$BASE/.claude/skills"
fi
