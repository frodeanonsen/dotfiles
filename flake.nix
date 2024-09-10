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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)
    nixpkgs-lib.url = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05"; # Stable Nix Packages
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations
    zig.url = "github:mitchellh/zig-overlay";

    # User Environment Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-lib"; # not needed by NixOS' module thanks to `home-manager.useGlobalPkgs = true` but needed by the unpriviledged module
    };

    # MacOS Package Management
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      zig,
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
            nixpkgs-stable
            zig
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
            nixpkgs-stable
            zig
            home-manager
            vars
            ;
        }
      );
    };
}
