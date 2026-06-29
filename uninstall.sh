#!/usr/bin/env bash
set -euo pipefail

unlink_config() {
  local dest="$1"
  if [ -L "$dest" ]; then
    rm "$dest"
    echo "Removed: $dest"
  elif [ -e "$dest" ]; then
    echo "Skipping: $dest exists but is not a symlink"
  else
    echo "Not found: $dest"
  fi
}

unlink_config "$HOME/.config/nvim"
unlink_config "$HOME/.config/wezterm"
unlink_config "$HOME/.config/tmux"
