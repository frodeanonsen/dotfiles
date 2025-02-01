#!/usr/bin/env bash
nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#BodBook
