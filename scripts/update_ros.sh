#!/usr/bin/env sh
cd "$DOTFILES" || exit
nix flake update
home-manager switch --flake .#Ros
