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
    computerName = "ZygBook";
    hostName = "zygbook";
  };

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  homebrew = {

    taps = [
      "nikitabobko/tap" # Aerospace
    ];

    casks = [
      "monitorcontrol"
      "vlc"
      "1password"
      "aerospace"
      "orcaslicer"
      "openscad@snapshot"
      "ghostty"
      "raspberry-pi-imager"
    ];

    brews = [
      "aztfexport" # Move package to nix and use in devbox instead
      "stlink" # stlink tools
      {
        name = "libpq"; # Postgres C API library
        link = true;
      }
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      vfkit # Simple command line tool to start VMs through the macOS Virtualization framework
      colima # Docker container runtimes with minimal setup
      podman
      podman-tui # Podman Terminal UI
    ];
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
      ".config/aerospace".source = ../config/aerospace;
      ".config/wezterm".source = ../config/wezterm;
      ".config/tmux".source = ../config/tmux;
      ".config/nix".source = ../config/nix;
      ".config/borders".source = ../config/borders;
    };

    home.sessionVariables = { };

    home.sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];

    # Makes sense for user specific applications that shouldn't be available system-wide
    home.packages = with pkgs; [
      home-assistant-cli
      act # https://github.com/nektos/act - Run your GitHub Actions locally
      exercism
      qmk
      yazi
      zellij
      nmap
      dfu-util
      slack
      pngpaste
      entr
      dotenvx # .env file manager
      postgresql
      jankyborders # add colored borders to user windows on macOS
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.jankyborders = {
    enable = true;
    style = "round";
    width = 6.0;
    hidpi = false;
    active_color = "0xffe1e300";
    inactive_color = "0xff494d64";
  };

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

    stateVersion = 4;
  };
}
