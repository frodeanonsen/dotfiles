# Set up local environment variables
if test -e $HOME/.env.fish
    source $HOME/.env.fish
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x TERM xterm-256color

    # Install fisher if not installed
    if not test -e ~/.config/fish/functions/fisher.fish
        echo "Installing fisher"
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end

    # Install bass
    if not test -e ~/.config/fish/functions/bass.fish
        echo "Installing bass"
        fisher install edc/bass
    end

    # Update theme based on system preference
    update_theme
end
