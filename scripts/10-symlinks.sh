#!/usr/bin/env bash
# Symlink configs into place using GNU stow.
#   home/   -> ~
#   config/ -> ~/.config
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

require_cmd stow

if [[ -d "$REPO_ROOT/home" ]]; then
  info "Stowing home/ -> $HOME"
  stow --dir "$REPO_ROOT" --target "$HOME" --restow home
fi

if [[ -d "$REPO_ROOT/config" ]]; then
  info "Stowing config/ -> $HOME/.config"
  mkdir -p "$HOME/.config"
  stow --dir "$REPO_ROOT" --target "$HOME/.config" --restow config
fi

ok "symlinks in place"
