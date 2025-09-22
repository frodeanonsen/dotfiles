#!/usr/bin/env bash

process="${1:-nvim}"

# Print unique tmux session names that currently host panes running the target command
TMUX_FORMAT='#{session_name} #{pane_current_command}'

TMUX_CMD=(tmux list-panes -a -F "$TMUX_FORMAT")

"${TMUX_CMD[@]}" \
  | awk -v process="$process" '$2 == process {print $1}' \
  | sort -u
