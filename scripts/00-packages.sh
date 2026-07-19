#!/usr/bin/env bash
# Install packages from packages/*.txt using yay (which wraps pacman, so it
# handles both official-repo and AUR packages). No direct pacman calls.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# yay is required for the whole package step. EndeavourOS ships it by default.
require_cmd yay

# Combine repo + AUR lists into a single yay invocation. yay resolves each
# package from the correct source automatically.
mapfile -t pkgs < <(cat \
  <(read_list "$REPO_ROOT/packages/pacman.txt") \
  <(read_list "$REPO_ROOT/packages/aur.txt"))

if ((${#pkgs[@]})); then
  info "Installing ${#pkgs[@]} package(s) via yay (full sync/upgrade)"
  yay -Syu --needed --noconfirm "${pkgs[@]}"
else
  warn "no packages listed in packages/pacman.txt or packages/aur.txt, skipping"
fi

# --- flatpak -----------------------------------------------------------------
mapfile -t flat < <(read_list "$REPO_ROOT/packages/flatpak.txt")
if ((${#flat[@]})); then
  if command -v flatpak >/dev/null 2>&1; then
    info "Installing ${#flat[@]} flatpak app(s)"
    flatpak install -y flathub "${flat[@]}"
  else
    warn "flatpak not installed, skipping ${#flat[@]} app(s)"
  fi
fi

ok "package install complete"
