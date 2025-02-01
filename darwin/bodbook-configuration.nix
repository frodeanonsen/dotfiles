#
#  Main MacOS system configuration.
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ darwin-configuration.nix *
#       └─ ./modules
#           └─ default.nix
#

{
  pkgs,
  vars,
  ...
}:

{
  imports = [
    ./common.nix
  ];

  networking = {
    computerName = "BodBook";
    hostName = "bodbook";
  };

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  security.pam.enableSudoTouchIdAuth = true;

  home-manager.backupFileExtension = "backup";
  home-manager.users.${vars.user} = {
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;
    programs.zsh = {
      initExtra = ''
        # Add any additional configurations here
        export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
      '';
    };

    home.file = {
      ".zshrc".source = ../config/zsh/zshrc;
      ".bashrc".source = ../config/bash/bashrc;
      ".gitignore".source = ../config/git/gitignore;
      ".gitconfig".source = ../config/git/gitconfig;
      ".editorconfig".source = ../config/system/editorconfig;
      ".config/ohmyposh".source = ../config/ohmyposh;
      ".config/nvim".source = ../config/lazyvim;
      ".config/fish".source = ../config/fish;
      ".config/wezterm".source = ../config/wezterm;
      ".config/tmux".source = ../config/tmux;
      ".config/nix".source = ../config/nix;
    };

    home.sessionVariables = { };

    home.sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];

    # Makes sense for user specific applications that shouldn't be available system-wide
    home.packages = with pkgs; [
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Testing new settings:
  # keep-outputs = true
  # keep-derivations = true
  # keep-failed = false
  # keep-going = true
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      keep-failed = false
      keep-going = true
    '';
    configureBuildUsers = true;
    useDaemon = true;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "frode"
      ];
    };
  };

  system = {
    defaults = {
      dock.autohide = true;
      dock.mru-spaces = false;
      dock.orientation = "left";
      finder.AppleShowAllExtensions = true;
      finder.FXPreferredViewStyle = "clmv";
      loginwindow.LoginwindowText = "Zygizo";
      screencapture.location = "~/Desktop/Screenshots";
      screensaver.askForPasswordDelay = 10;
    };

    stateVersion = 5;
  };
}
