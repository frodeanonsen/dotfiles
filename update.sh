#!/usr/bin/env sh
cd ~/.dotfiles || exit

nix flake update
# darwin-rebuild switch --flake .
darwin-rebuild switch --flake .#MacBookApple
