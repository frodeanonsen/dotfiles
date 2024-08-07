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
      yabai
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
      azure-cli
      azure-functions-core-tools
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
      "raycast"
      "freecad"
      "monitorcontrol"
      "1password-cli"
      "obsidian"
      "raycast"
      "vlc"
    ];
    brews = [
      "arm-none-eabi-gdb"
      "armmbed/formulae/arm-none-eabi-gcc"
      "aztfexport"
      "terraform"
      "terraform-ls"
      "matplotplusplus"
      "nvm"
      "stlink"
    ];
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
      ".config/yabai".source = ../config/yabai;
      ".config/wezterm".source = ../config/wezterm;
      ".config/tmux".source = ../config/tmux;
      ".config/gh".source = ../config/gh;
      ".config/nix".source = ../config/nix;
    };

    home.sessionVariables = {
    };

    home.sessionPath = [
      "/run/current-system/sw/bin"
        "$HOME/.nix-profile/bin"
    ];

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

  services.yabai.enable = true;
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
