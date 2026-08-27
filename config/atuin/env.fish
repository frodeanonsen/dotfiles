if status is-interactive
    and command -q atuin
    set -gx ATUIN_CONFIG_DIR $HOME/.config/atuin
    atuin init fish | source
end
