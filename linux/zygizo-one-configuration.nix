{ config, pkgs, vars, ... }:

{
  programs.zsh.enable = true;
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = "${vars.user}";
  home.homeDirectory = "/home/${vars.user}";
  home.file = {
    ".zshrc".source = ../config/zsh/zshrc;
    ".bashrc".source = ../config/bash/bashrc;
    ".gitignore".source = ../config/git/gitignore;
    ".editorconfig".source = ../config/system/editorconfig;
    ".config/ohmyposh".source = ../config/ohmyposh;
    ".config/nvim".source = ../config/lazyvim;
    ".config/fish".source = ../config/fish;
    ".config/tmux".source = ../config/tmux;
    ".config/nix".source = ../config/nix;
    ".config/zellij".source = ../config/zellij;
    ".config/wezterm".source = ../config/wezterm;
    ".config/atuin".source = ../config/atuin;
    # Claude Code writes settings.json back when a setting changes, so these
    # point at the checkout rather than a read-only copy in the store.
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/claude/settings.json";
    ".claude/statusline.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/claude/statusline.sh";
  };

  home.packages = with pkgs; [
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
    bottom
    fd
    fzf
    eza
    gawk
    jq
    yq
    lazygit
    lazydocker
    zsh
    tldr
    xh
    wget
    hwatch
    watchman
    yazi
    lnav
    cmake
    cmake-lint
    oh-my-posh
    zellij
    zoxide
    atuin
    platformio-core
    terraform
    terraform-ls
    tflint
    rustup
    poetry
    openocd
    devbox
    monaspace
    podman
    testdisk
    starship
  ];

}
