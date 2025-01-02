#!/usr/bin/env sh

cd ~/.dotfiles || exit
nix flake update
home-manager switch --flake .#ZygizoOne
