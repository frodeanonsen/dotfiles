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
      python312Packages.tkinter
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
      upgrade = false;
      cleanup = "zap";
    };
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
      "nikitabobko/tap/aerospace"
    ];
    brews = [
      "arm-none-eabi-gdb"
      "armmbed/formulae/arm-none-eabi-gcc"
      "aztfexport"
      "matplotplusplus"
      "nvm"
      "stlink"
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
      ".config/ohmyposh".source = ../config/ohmyposh;
      ".config/nvim".source = ../config/lazyvim;
      ".config/skhd".source = ../config/skhd;
      ".config/aerospace".source = ../config/aerospace;
      ".config/wezterm".source = ../config/wezterm;
      ".config/tmux".source = ../config/tmux;
      ".config/gh".source = ../config/gh;
      ".config/nix".source = ../config/nix;
      ".config/zellij".source = ../config/zellij;
    };

    home.sessionVariables = {
    };

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
      oh-my-posh
      exercism
      qmk
      yazi
      zellij
      zoxide
      rustup
      tflint
      python312Packages.west
      azure-cli
      azure-functions-core-tools
      platformio-core
      nmap
      plantuml
      dfu-util
      terraform
      terraform-ls
      slack
      pngpaste
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
