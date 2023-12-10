#!/usr/bin/env bash

if [[ ! -d ~/.local/share/tmux ]]; then
  mkdir -p ~/.local/share/tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm
fi

echo "Run <prefix> I to install plugins"
