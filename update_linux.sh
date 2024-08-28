#!/usr/bin/env sh
cd $DOTFILES
nix flake update
home-manager switch --flake .#ZygizoOne
