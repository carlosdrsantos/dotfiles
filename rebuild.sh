#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
if command -v darwin-rebuild >/dev/null; then
  exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
fi
# First run on a new machine: nix-darwin is not installed yet.
exec sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.dotfiles#mac
