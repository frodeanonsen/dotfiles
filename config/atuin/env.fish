# Shell history via atuin. Ctrl-R opens the search; the up arrow keeps fish's
# own history search.
if status is-interactive
    and command -q atuin
    set -gx ATUIN_CONFIG_DIR $HOME/.config/atuin
    atuin init fish --disable-up-arrow | source
end
