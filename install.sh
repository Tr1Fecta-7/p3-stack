#!/usr/bin/env bash
# Install p3-stack skills. T3 Code threads load skills through their provider:
# Claude threads (Agent SDK) read .claude/skills, Codex reads .agents/skills.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCOPE=""
BASE=""
CLAUDE=0

usage() {
  cat <<'EOF'
usage: ./install.sh --global [--claude]
       ./install.sh --project /path/to/repo [--claude]

  --global          link into ~/.agents/skills
  --project PATH    link into PATH/.agents/skills
  --claude          also link into .claude/skills (Claude threads and Claude Code)
EOF
}

set_scope() {
  if [[ -n "$SCOPE" ]]; then
    echo 'install.sh: choose one of --global or --project' >&2
    exit 1
  fi
  SCOPE="$1"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) set_scope global; BASE="$HOME"; shift ;;
    --project)
      set_scope project
      if [[ $# -lt 2 ]]; then usage >&2; exit 1; fi
      if [[ ! -d "$2" ]]; then
        printf 'install.sh: not a directory: %s\n' "$2" >&2
        exit 1
      fi
      BASE="$(cd "$2" && pwd)"
      shift 2 ;;
    --claude) CLAUDE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done

if [[ -z "$SCOPE" ]]; then
  usage >&2
  exit 1
fi

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
