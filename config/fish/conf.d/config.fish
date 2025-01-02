if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    sh /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source
    set -gx PATH /run/current-system/sw/bin /etc/profiles/per-user/$USER/bin $PATH
end

set dotfiles $HOME/.dotfiles

# All of our Fish files, excluding $dotfiles/config/fish
set config_files (string match -v "$dotfiles/config/fish/*" $dotfiles/config/*/*.fish)

# Load the path files
for file in $config_files
    if string match -r '.*/path\.fish$' -- $file
        source $file
    end
end

# Load everything but the path and completion files
for file in $config_files
    if not string match -r '.*/path\.fish$' -- $file
        if not string match -r '.*/completion\.fish$' -- $file
            source $file
        end
    end
end
