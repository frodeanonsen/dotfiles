# FZF and FD helpers for NeoVim. Omarchy's fzf key bindings read
# FZF_CTRL_T_COMMAND at invocation time, so this also drives Ctrl-T.
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
