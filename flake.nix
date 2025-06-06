#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # Nix Packages (Default)
    nixpkgs-lib.url = "github:nixos/nixpkgs/nixos-25.05?dir=lib";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)
    nixpkgs-lib-unstable.url = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    # User Environment Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-lib"; # not needed by NixOS' module thanks to `home-manager.useGlobalPkgs = true` but needed by the unpriviledged module
    };

    # MacOS Package Management
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      darwin,
      ...
    }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "frode";
        location = "$HOME/.dotfiles";
        terminal = "wezterm";
        editor = "nvim";
      };
    in
    {
      # nixosConfigurations = (
      #   import ./hosts {
      #     inherit (nixpkgs) lib;
      #     inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager vars; # Inherit inputs
      #   }
      # );

      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            nixpkgs-unstable
            home-manager
            darwin
            vars
            ;
        }
      );

      homeConfigurations = (
        import ./linux {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            nixpkgs-unstable
            home-manager
            vars
            ;
        }
      );
    };
}
