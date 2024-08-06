# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
   home.username = "frode";
   home.homeDirectory = "/Users/frode";
   home.stateVersion = "23.05"; # Please read the comment before changing.

   # Makes sense for user specific applications that shouldn't be available system-wide
   home.packages = [
      pkgs.htop
          pkgs.home-assistant-cli
          pkgs.podman
          pkgs.podman-tui
          pkgs.poetry
          pkgs.act
          pkgs.bear
          pkgs.boost-build
          pkgs.bossa
          pkgs.llvm_16
          pkgs.ccls
          pkgs.cmake
          pkgs.oh-my-posh
          pkgs.exercism
          pkgs.qmk
          pkgs.yazi
          pkgs.zellij
          pkgs.zoxide
          pkgs.rustup
          pkgs.tflint
          pkgs.python312Packages.west
          pkgs.azure-cli
          pkgs.azure-functions-core-tools
          pkgs.platformio-core
          pkgs.nmap
          pkgs.plantuml
          pkgs.dfu-util
   ];

   # Home Manager is pretty good at managing .dotfiles. The primary way to manage
   # plain files is through 'home.file'.
   home.file = {
     ".zshrc".source = ./config/zsh/zshrc;
     ".config/ohmyposh".source = ./config/ohmyposh;
     ".config/nvim".source = ./config/lazyvim;
     ".config/skhd".source = ./config/skhd;
     ".config/yabai".source = ./config/yabai;
     ".config/wezterm".source = ./config/wezterm;
     ".config/tmux".source = ./config/tmux;
     ".config/gh".source = ./config/gh;
     ".config/nix".source = ./config/nix;
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
