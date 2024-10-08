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

{ pkgs, vars, ... }:

{
  imports = (import ./modules);

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      nixfmt-rfc-style
      vim
      neovim
      tree-sitter
      tmux
      git
      gh
      direnv
      bat
      ripgrep
      age
      sshs
      atac
      termshark
      portal
      glow
      btop
      bottom
      fd
      fzf
      eza
      gawk
      skhd
      raycast
      _1password
      jq
      yq
      lazygit
      darwin.lsusb
      zsh
      yt-dlp
      tldr
      xh
      wget
      hwatch
      watchman
      gnumake
      gettext
      tk
      python3
      python312Packages.pip
      python312Packages.tkinter
      pyenv
    ];
  };

  fonts.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "Monaspace" ]; })
    monaspace
  ];

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "nikitabobko/tap"
      "cfergeau/crc"
    ];

    casks = [
      "wireshark"
      "google-chrome"
      "firefox"
      "freecad"
      "monitorcontrol"
      "obsidian"
      "vlc"
      "1password"
      "orcaslicer"
      "aerospace"
      "openscad@snapshot"
    ];

    brews = [
      "azure-cli"
      "aztfexport"
      "matplotplusplus"
      "nvm"
      "stlink"
      "vfkit"
      "ktlint"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Home Assistant" = 1099568401;
      "MQTT Explorer" = 1455214828;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  home-manager.backupFileExtension = "backup";
  home-manager.users.${vars.user} = {
    home.stateVersion = "23.05";
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

    # Home Manager is pretty good at managing .dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      ".zshrc".source = ../config/zsh/zshrc;
      ".bashrc".source = ../config/bash/bashrc;
      ".gitignore".source = ../config/git/gitignore;
      ".editorconfig".source = ../config/system/editorconfig;
      ".config/ohmyposh".source = ../config/ohmyposh;
      ".config/nvim".source = ../config/lazyvim;
      ".config/skhd".source = ../config/skhd;
      ".config/aerospace".source = ../config/aerospace;
      ".config/wezterm".source = ../config/wezterm;
      ".config/tmux".source = ../config/tmux;
      ".config/nix".source = ../config/nix;
      ".config/zellij".source = ../config/zellij;
    };

    home.sessionVariables = { };

    home.sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];

    # Makes sense for user specific applications that shouldn't be available system-wide
    home.packages = with pkgs; [
      htop
      home-assistant-cli
      podman
      podman-tui
      poetry
      act
      bear
      boost-build
      bossa
      llvm_16
      ccls
      cmake
      cmake-lint
      ninja
      oh-my-posh
      exercism
      qmk
      yazi
      zellij
      zoxide
      rustup
      tflint
      python312Packages.west
      platformio-core
      nmap
      plantuml
      dfu-util
      terraform
      terraform-ls
      slack
      pngpaste
      # gcc-arm-embedded-13 // Problematic
      entr
      zigpkgs.master
      openocd
      colima
      docker
      docker-buildx
      dotenvx
      qalculate-qt
      dust
      duf
      postgresql
      azure-cli
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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
    '';
    configureBuildUsers = true;
    useDaemon = true;
    settings.experimental-features = "nix-command flakes";
  };

  services.skhd.enable = true;

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
