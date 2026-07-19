#!/usr/bin/env bash
# Shared helpers sourced by the other scripts.

set -euo pipefail

# Repo root, regardless of where a script is invoked from.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

# --- logging -----------------------------------------------------------------
_c_reset=$'\e[0m'; _c_blue=$'\e[34m'; _c_green=$'\e[32m'; _c_yellow=$'\e[33m'; _c_red=$'\e[31m'

info()  { printf '%s==>%s %s\n' "$_c_blue"   "$_c_reset" "$*"; }
ok()    { printf '%s ok%s %s\n' "$_c_green"  "$_c_reset" "$*"; }
warn()  { printf '%swarn%s %s\n' "$_c_yellow" "$_c_reset" "$*" >&2; }
err()   { printf '%serr%s %s\n'  "$_c_red"    "$_c_reset" "$*" >&2; }

# Read a package list: strip comments and blank lines.
read_list() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  # strip comments (whole-line and inline), trim leading/trailing whitespace,
  # then drop blank lines.
  sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$file"
}

# Ensure a command exists, or exit with a helpful message.
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "missing required command: $1"; exit 1; }
}
