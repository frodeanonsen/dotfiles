{ pkgs, vars, ... }:

{
  programs.zsh.enable = true;
  programs.home-manager.enable = true;
  
  home.stateVersion = "23.05";
  home.username = "${vars.user}";
  home.homeDirectory = "/home/${vars.user}";
  home.file = {
    ".zshrc".source = ../config/zsh/zshrc;
    ".bashrc".source = ../config/bash/bashrc;
    ".gitconfig".source = ../config/git/gitconfig;
    ".gitignore".source = ../config/git/gitignore;
    ".editorconfig".source = ../config/system/editorconfig;
    ".config/ohmyposh".source = ../config/ohmyposh;
    ".config/nvim".source = ../config/lazyvim;
    ".config/tmux".source = ../config/tmux;
    ".config/nix".source = ../config/nix;
    ".config/zellij".source = ../config/zellij;
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
    btop
    bottom
    fd
    fzf
    eza
    gawk
    jq
    yq
    lazygit
    zsh
    tldr
    xh
    wget
    hwatch
    watchman
    yazi
    nodejs_22
    cmake
    cmake-lint
    oh-my-posh
    zellij
    zoxide
    platformio-core
    terraform
    terraform-ls
    zigpkgs.master
    tflint
    rustup
    poetry
    openocd
  ];

}
