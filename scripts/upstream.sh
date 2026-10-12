#!/usr/bin/env bash
# Track upstream pstack (cursor/plugins) against the commit pinned in UPSTREAM.
#
#   scripts/upstream.sh status          pinned vs upstream HEAD, commits since the pin
#   scripts/upstream.sh files [REF]     changed upstream files mapped to their p3-stack path
#   scripts/upstream.sh diff [REF] [P]  upstream diff since the pin, optionally limited to upstream paths P
#   scripts/upstream.sh pin [REF]       move the pin to REF (default: upstream HEAD) once the port is done
#
# REF defaults to upstream HEAD (origin/main). The upstream clone is cached in
# ${XDG_CACHE_HOME:-~/.cache}/p3-stack/cursor-plugins.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/UPSTREAM"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/p3-stack/cursor-plugins"

sync_cache() {
  if [[ -d "$CACHE/.git" ]]; then
    git -C "$CACHE" fetch --quiet origin
  else
    mkdir -p "$(dirname "$CACHE")"
    git clone --quiet --filter=blob:none --no-checkout "$UPSTREAM_REPO" "$CACHE"
  fi
}

up() { git -C "$CACHE" "$@"; }

resolve() { up rev-parse --verify "${1:-origin/main}^{commit}"; }

# Upstream path (relative to UPSTREAM_PATH) -> p3-stack path, or "-" when p3-stack does not port it.
map_path() {
  case "$1" in
    .cursor-plugin/*|plugin.json|assets/*|automations/*|docs/*|LICENSE|.gitignore) echo "-" ;;
    skills/poteto-mode/scripts/*) echo "-" ;;
    skills/poteto-mode/*) echo "skills/p3-mode/${1#skills/poteto-mode/}" ;;
    skills/poteto-help/*) echo "skills/p3-help/${1#skills/poteto-help/}" ;;
    skills/setup-pstack/*) echo "skills/setup-p3/${1#skills/setup-pstack/}" ;;
    agents/poteto-agent.md) echo "agents/p3-agent.md" ;;
    *) echo "$1" ;;
  esac
}

cmd_status() {
  local head
  head="$(resolve "${1:-}")"
  printf 'pinned  %s (pstack %s)\n' "${UPSTREAM_COMMIT:0:7}" "$UPSTREAM_VERSION"
  printf 'target  %s (pstack %s)\n\n' "${head:0:7}" "$(version_at "$head")"
  up log --format='%h %ad %s' --date=short "$UPSTREAM_COMMIT..$head" -- "$UPSTREAM_PATH"
}

cmd_files() {
  local head status path target note
  head="$(resolve "${1:-}")"
  while IFS=$'\t' read -r status path; do
    path="${path#"$UPSTREAM_PATH"/}"
    target="$(map_path "$path")"
    note=""
    if [[ "$target" == "-" ]]; then
      note="(not ported)"
    elif [[ ! -e "$ROOT/$target" ]]; then
      note="(new in p3-stack)"
    fi
    printf '%s\t%-60s -> %s %s\n' "$status" "$path" "$target" "$note"
  done < <(up diff --name-status --no-renames "$UPSTREAM_COMMIT" "$head" -- "$UPSTREAM_PATH")
}

cmd_diff() {
  local head paths=()
  head="$(resolve "${1:-}")"
  shift || true
  if [[ $# -eq 0 ]]; then
    paths=("$UPSTREAM_PATH")
  else
    for p in "$@"; do paths+=("$UPSTREAM_PATH/${p#"$UPSTREAM_PATH"/}"); done
  fi
  up --no-pager diff "$UPSTREAM_COMMIT" "$head" -- "${paths[@]}"
}

version_at() {
  up show "$1:$UPSTREAM_PATH/.cursor-plugin/plugin.json" 2>/dev/null \
    | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' | head -1
}

cmd_pin() {
  local head version
  head="$(resolve "${1:-}")"
  version="$(version_at "$head")"
  sed -i.bak \
    -e "s/^UPSTREAM_COMMIT=.*/UPSTREAM_COMMIT=$head/" \
    -e "s/^UPSTREAM_VERSION=.*/UPSTREAM_VERSION=$version/" \
    "$ROOT/UPSTREAM"
  rm "$ROOT/UPSTREAM.bak"
  printf 'pinned %s (pstack %s). Add a CHANGES.md entry for this sync.\n' "${head:0:7}" "$version"
}

sync_cache
case "${1:-status}" in
  status) shift || true; cmd_status "$@" ;;
  files) shift; cmd_files "$@" ;;
  diff) shift; cmd_diff "$@" ;;
  pin) shift; cmd_pin "$@" ;;
  *) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
