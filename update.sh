#!/usr/bin/env sh
cd $DOTFILES
nix flake update
# darwin-rebuild switch --flake .
darwin-rebuild switch --flake .#MacBookApple
