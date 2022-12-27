#!/usr/bin/env bash

if [[ ! -d ~/.config/nvim ]]; then
  if [[ -d ~/.local/share/nvim ]]; then
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
  fi
  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  nvim +PackerSync
fi
