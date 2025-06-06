#!/usr/bin/env bash

if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
  echo "Dark mode"
  tmux source-file ~/.config/tmux/tokyonight_night.tmux
else
  echo "Light mode"
  tmux source-file ~/.config/tmux/tokyonight_day.tmux
fi
