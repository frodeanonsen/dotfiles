{ config, lib, system, pkgs, stable, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      vim
      neovim
      tree-sitter
      go
      nodejs
      python3
      ripgrep
    ];
  };

}
