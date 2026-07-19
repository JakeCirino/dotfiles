#!/usr/bin/env bash
# Install oh-my-zsh + Powerlevel10k + plugins (git clones into the omz custom dir),
# matching the theme/plugin names referenced in home/.zshrc.
#
# Idempotent: skips anything already present. Config files (~/.zshrc, ~/.p10k.zsh)
# are handled by the symlink step, not here.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

require_cmd git

ZSH_DIR="$HOME/.oh-my-zsh"
CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

# --- oh-my-zsh ---------------------------------------------------------------
if [[ -d "$ZSH_DIR" ]]; then
  ok "oh-my-zsh already installed"
else
  info "Installing oh-my-zsh (unattended)"
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- clone helper ------------------------------------------------------------
clone() {  # clone <repo-url> <dest>
  local url="$1" dest="$2"
  if [[ -d "$dest" ]]; then
    ok "$(basename "$dest") already present"
  else
    info "Cloning $(basename "$dest")"
    git clone --depth=1 "$url" "$dest"
  fi
}

# --- theme -------------------------------------------------------------------
clone https://github.com/romkatv/powerlevel10k.git "$CUSTOM/themes/powerlevel10k"

# --- plugins -----------------------------------------------------------------
clone https://github.com/zsh-users/zsh-autosuggestions.git      "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git  "$CUSTOM/plugins/zsh-syntax-highlighting"

ok "zsh environment ready (run 'chsh -s \$(which zsh)' to make zsh your login shell, if desired)"
