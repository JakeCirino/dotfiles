# dotfiles

Personal EndeavourOS (Arch-based) system setup: package lists and configuration,
so a fresh machine can be brought up to a known state.

## Layout

```
.
├── install.sh          # bootstrap entrypoint; runs scripts/ in order
├── packages/           # package manifests (plain text, one per line)
│   ├── pacman.txt      #   native repo packages
│   ├── aur.txt         #   AUR packages (yay/paru)
│   └── flatpak.txt     #   flatpak apps
├── scripts/
│   ├── lib.sh          # shared helpers
│   ├── 00-packages.sh  # install packages from packages/*.txt
│   └── 10-symlinks.sh  # symlink configs via GNU stow
├── config/             # mirrors ~/.config   (stowed into ~/.config)
└── home/               # mirrors ~ dotfiles  (stowed into ~)
```

## Fresh install

```bash
sudo pacman -S --needed git stow
git clone <this-repo-url> ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

Run a single step by passing a filter, e.g. `./install.sh 10` for symlinks only.

## Adding configs

Configs are symlinked with [GNU Stow](https://www.gnu.org/software/stow/). Place a
file at the path it should occupy relative to its target root, then re-run the
symlink step.

- A file for `~/.config/foo/bar.conf` lives at `config/foo/bar.conf`.
- A file for `~/.bashrc` lives at `home/.bashrc`.

```bash
./install.sh 10   # restow
```

## Updating package lists

```bash
pacman -Qqen > packages/pacman.txt   # native explicit
pacman -Qqem > packages/aur.txt      # AUR / foreign
flatpak list --app --columns=application > packages/flatpak.txt
```
