#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"

ln -sfn "$REPO_ROOT/nvim" "$HOME/.config/nvim"
ln -sfn "$REPO_ROOT/wezterm" "$HOME/.config/wezterm"
ln -sfn "$REPO_ROOT/tmux" "$HOME/.config/tmux"
