#!/usr/bin/env bash
# Bootstrap entrypoint. Runs the numbered scripts in scripts/ in order.
#
# Usage:
#   ./install.sh            # run everything
#   ./install.sh 10         # run only the step(s) matching "10"
source "$(dirname "${BASH_SOURCE[0]}")/scripts/lib.sh"

filter="${1:-}"

shopt -s nullglob
for step in "$REPO_ROOT"/scripts/[0-9][0-9]-*.sh; do
  name="$(basename "$step")"
  if [[ -n "$filter" && "$name" != *"$filter"* ]]; then
    continue
  fi
  info "Running $name"
  bash "$step"
done

ok "bootstrap complete"
