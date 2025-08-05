#
#  flake.nix - Nix, NixOS and Nix Darwin System Configuration
#   ├─ ./darwin - macOS configurations
#   └─ ./linux - Linux home-manager configurations
#

{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # User Environment Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # MacOS Package Management

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      darwin,
      ...
    }:
    let
      vars = {
        user = "frode";
        location = "$HOME/.dotfiles";
        terminal = "wezterm";
        editor = "nvim";
      };

      inputs = {
        inherit
          nixpkgs
          nixpkgs-unstable
          nixos-hardware
          home-manager
          darwin
          ;
      };
    in
    {
      darwinConfigurations = import ./darwin {
        inherit (nixpkgs) lib;
        inherit
          inputs
          nixpkgs
          nixpkgs-unstable
          home-manager
          darwin
          vars
          ;
      };

      homeConfigurations = import ./linux {
        inherit (nixpkgs) lib;
        inherit
          inputs
          nixpkgs
          nixpkgs-unstable
          home-manager
          vars
          ;
      };
    };
}
