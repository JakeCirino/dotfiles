#!/usr/bin/env bash
# Install packages from packages/*.txt
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# --- native (pacman) ---------------------------------------------------------
mapfile -t pac < <(read_list "$REPO_ROOT/packages/pacman.txt")
if ((${#pac[@]})); then
  info "Installing ${#pac[@]} native package(s) via pacman (full sync/upgrade)"
  sudo pacman -Syu --needed --noconfirm "${pac[@]}"
else
  warn "packages/pacman.txt is empty, skipping"
fi

# --- AUR ---------------------------------------------------------------------
mapfile -t aur < <(read_list "$REPO_ROOT/packages/aur.txt")
if ((${#aur[@]})); then
  helper=""
  for h in yay paru; do command -v "$h" >/dev/null 2>&1 && { helper="$h"; break; }; done
  if [[ -z "$helper" ]]; then
    warn "no AUR helper (yay/paru) found, skipping ${#aur[@]} AUR package(s)"
  else
    info "Installing ${#aur[@]} AUR package(s) via $helper (full sync/upgrade)"
    "$helper" -Syu --needed --noconfirm "${aur[@]}"
  fi
else
  warn "packages/aur.txt is empty, skipping"
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
