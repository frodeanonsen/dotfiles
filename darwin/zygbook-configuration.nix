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
  unstable,
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
      "FelixKratz/formulae" # JankyBorders
    ];

    casks = [
      "monitorcontrol"
      "vlc"
      "aerospace"
      "openscad@snapshot"
      "gimp"
      "ungoogled-chromium"
    ];

    brews = [
      "aztfexport" # Move package to nix and use in devbox instead
      "stlink" # stlink tools
      {
        name = "libpq"; # Postgres C API library
        link = true;
      }
      "borders" # add colored borders to user windows on macOS
      "sketchybar"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      vfkit # Simple command line tool to start VMs through the macOS Virtualization framework
      colima # Docker container runtimes with minimal setup
      podman # Podman container runtime
      podman-tui # Podman Terminal UI
      ffmpeg-full # Full version of FFmpeg with all codecs
      unstable.talosctl # Talos CLI tool
      kubectl
      kubectx
      k9s
      stern
    ];
  };

  # Removed in 2025.05
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.backupFileExtension = "backup";
  home-manager.users.${vars.user} = {
    home.stateVersion = "25.05";
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
      ".config/sketchybar".source = ../config/sketchybar;
      ".config/wezterm".source = ../config/wezterm;
      ".config/kitty".source = ../config/kitty;
      ".config/tmux".source = ../config/tmux;
      ".config/nix".source = ../config/nix;
      ".config/borders".source = ../config/borders;
      ".config/lazygit".source = ../config/lazygit;
      ".config/starship".source = ../config/starship;
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
      nmap
      dfu-util
      slack
      pngpaste
      entr
      # dotenvx # .env file manager
      postgresql
      # sketchybar
      # jankyborders # add colored borders to user windows on macOS, temp moved to homebrew
      audacity

      # Language servers (for Zed)
      nil
      nixd
    ];
  };

  # Auto upgrade nix package and the daemon service.
  # removed in 2025.05
  # services.nix-daemon.enable = true;

  # services.jankyborders = {
  #   enable = true;
  #   style = "round";
  #   width = 6.0;
  #   hidpi = false;
  #   active_color = "0xffe1e300";
  #   inactive_color = "0xff494d64";
  # };

  # services.sketchybar = {
  #   enable = true;
  #   package = pkgs.sketchybar;
  # };

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
      auto-optimise-store = false
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      keep-failed = false
      keep-going = true
    '';
    # Removed in 2025.05
    # configureBuildUsers = true;
    # useDaemon = true;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
      ];
      substituters = [
        "https://cache.nixos.org"
        # add others like Cachix here
      ];
    };
  };

  system = {
    primaryUser = "frode";
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
