# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
   home.username = "frode";
   home.homeDirectory = "/Users/frode";
   home.stateVersion = "23.05"; # Please read the comment before changing.

   # Makes sense for user specific applications that shouldn't be available system-wide
   home.packages = [
   ];

   # Home Manager is pretty good at managing .dotfiles. The primary way to manage
   # plain files is through 'home.file'.
   home.file = {
     ".zshrc".source = ./config/zsh/zshrc.symlink;
     ".config/ohmyposh".source = ./config/ohmyposh;
     ".config/nvim".source = ./config/lazyvim;
     # ".config/wezterm".source = /Users/frode/.dotfiles/wezterm;
     # ".config/skhd".source = /Users/frode/.dotfiles/skhd;
     # ".config/tmux".source = /Users/frode/.dotfiles/tmux;
     # ".config/nix".source = /Users/frode/.dotfiles/nix;
     # ".config/nix-darwin".source = /Users/frode/.dotfiles/nix-darwin;
   };

   home.sessionVariables = {
   };

   home.sessionPath = [
     "/run/current-system/sw/bin"
       "$HOME/.nix-profile/bin"
   ];
   programs.home-manager.enable = true;
   programs.zsh = {
     enable = true;
     initExtra = ''
       # Add any additional configurations here
       export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
       if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
         . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
       fi
     '';
   };
}
