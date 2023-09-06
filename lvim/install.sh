#!/usr/bin/env bash

if [[ ! -d ~/.config/lvim ]]; then
  if [[ -d ~/.local/share/lvim ]]; then
    mv ~/.local/share/lvim ~/.local/share/lvim.bak
  fi
  LV_BRANCH='release-1.3/neovim-0.9' curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh | bash -s -- --yes --no-install-dependencies
fi
