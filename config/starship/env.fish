if status is-interactive
    # Force starship config dir
    set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml

    starship init fish | source
end
