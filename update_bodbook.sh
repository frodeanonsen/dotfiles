#!/usr/bin/env sh
cd $DOTFILES
nix flake update
darwin-rebuild switch --flake .#BodBook
