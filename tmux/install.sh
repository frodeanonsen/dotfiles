#!/usr/bin/env bash

if [[ ! -d ~/.tmux ]]; then
  mkdir -p ~/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
