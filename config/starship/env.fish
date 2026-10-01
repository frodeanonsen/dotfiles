if status is-interactive
    # Omarchy hosts render the prompt with the current theme's colours (see
    # starship/env.bash); everywhere else use the linked config.
    set -l omarchy_starship $HOME/.local/state/omarchy/current/theme/starship.toml
    if test -f $omarchy_starship
        set -gx STARSHIP_CONFIG $omarchy_starship
    else
        set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    end

    starship init fish | source
end
