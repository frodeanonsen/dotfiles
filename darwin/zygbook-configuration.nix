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

let
  syncAlacrittyTheme = pkgs.writeShellScriptBin "sync-alacritty-theme" ''
    set -eu

    state_dir="/Users/${vars.user}/.local/state/alacritty"
    theme_file="$state_dir/theme.toml"
    light_theme="/Users/${vars.user}/.config/alacritty/catppuccin-latte.toml"
    dark_theme="/Users/${vars.user}/.config/alacritty/catppuccin-macchiato.toml"
    source_theme="$dark_theme"

    mkdir -p "$state_dir"

    if ! defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      source_theme="$light_theme"
    fi

    if ! cmp -s "$source_theme" "$theme_file" 2>/dev/null; then
      cp "$source_theme" "$theme_file"
    fi
  '';
in
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

    casks = [
      "monitorcontrol"
      "vlc"
      "openscad@snapshot" # OpenSCAD 3D modeling software
      "gimp" # GIMP photo editor
      "ungoogled-chromium" # Chromium
      "sol" # MacOS Launcher, alternative to Raycast, etc.
      "nikitabobko/tap/aerospace" # Aerospace window manager
    ];

    brews = [
      "aztfexport" # Move package to nix and use in devbox instead
      "mole" # macOS cleanup utility
      "open-ocd" # On-chip debugging, in-system programming and boundary-scan testing
      "stlink" # stlink tools
      {
        name = "libpq"; # Postgres C API library
        link = true;
      }
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      syncAlacrittyTheme
      vfkit # Simple command line tool to start VMs through the macOS Virtualization framework
      unstable.colima # Docker container runtimes with minimal setup
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

  launchd.user.agents.alacritty-theme-sync = {
    serviceConfig = {
      Label = "org.nixos.alacritty-theme-sync";
      ProgramArguments = [ "${syncAlacrittyTheme}/bin/sync-alacritty-theme" ];
      RunAtLoad = true;
      WatchPaths = [ "/Users/${vars.user}/Library/Preferences/.GlobalPreferences.plist" ];
      StandardOutPath = "/tmp/alacritty-theme-sync.out";
      StandardErrorPath = "/tmp/alacritty-theme-sync.err";
    };
  };

  # Removed in 2025.05
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  services.sketchybar.enable = true;
  services.jankyborders = {
    enable = true;
    active_color = "0xfff7768e";
    inactive_color = "0xff7aa2f7";
    hidpi = true;
    style = "round";
    width = 10.0;
  };

  home-manager.backupFileExtension = "backup";
  home-manager.users.${vars.user} = {
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

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
      postgresql
      audacity
      just

      # Language servers (for Zed)
      nil
      nixd

      # VSCode for nRF development
      vscode
    ];
  };

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
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
      ];
      substituters = [
        "https://cache.nixos.org"
        # add others like Cachix here
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        # cache.nixos.org is usually already present by default,
        # but keeping it explicit is fine:
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  system = {
    activationScripts.postActivation.text = ''
      user_home="/Users/${vars.user}"

      # Symlink dotfiles config to user home
      dotfiles="$user_home/.dotfiles/config"
      run_as_user() {
        sudo -u ${vars.user} "$@"
      }

      run_as_user mkdir -p "$user_home/.config"

      run_as_user ln -sfn "$dotfiles/zsh/zshrc" "$user_home/.zshrc"
      run_as_user ln -sfn "$dotfiles/bash/bashrc" "$user_home/.bashrc"
      run_as_user ln -sfn "$dotfiles/git/gitignore" "$user_home/.gitignore"
      run_as_user ln -sfn "$dotfiles/git/gitconfig" "$user_home/.gitconfig"
      run_as_user ln -sfn "$dotfiles/system/editorconfig" "$user_home/.editorconfig"

      run_as_user ln -sfn "$dotfiles/lazyvim" "$user_home/.config/nvim"
      run_as_user ln -sfn "$dotfiles/fish" "$user_home/.config/fish"
      run_as_user ln -sfn "$dotfiles/alacritty" "$user_home/.config/alacritty"
      run_as_user ln -sfn "$dotfiles/sketchybar" "$user_home/.config/sketchybar"
      run_as_user ln -sfn "$dotfiles/tmux" "$user_home/.config/tmux"
      run_as_user ln -sfn "$dotfiles/nix" "$user_home/.config/nix"
      run_as_user ln -sfn "$dotfiles/lazygit" "$user_home/.config/lazygit"
      run_as_user ln -sfn "$dotfiles/starship" "$user_home/.config/starship"
      run_as_user ln -sfn "$dotfiles/sol" "$user_home/.config/sol"
      run_as_user ${syncAlacrittyTheme}/bin/sync-alacritty-theme
    '';

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
