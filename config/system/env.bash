# Terminal editor for interactive shells. Omarchy's ~/.config/uwsm/default sets
# EDITOR=zed session-wide, which the GUI launchers use; zed is no good inside a
# terminal (git commit, crontab -e, etc.), so shells override it here.
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
