#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       ├─ darwin-configuraiton.nix
#       └─ <host>.nix
#

{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  darwin,
  home-manager,
  vars,
  ...
}:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  # # MacBook8,1 "Core M" 1.2 12" (2018)
  # MacBookIntel =
  #   let
  #     inherit (systemConfig "x86_64-darwin") system pkgs stable;
  #   in
  #   darwin.lib.darwinSystem {
  #     inherit system;
  #     specialArgs = { inherit inputs system pkgs stable vars; };
  #     modules = [
  #       ./darwin-configuration.nix
  #       ./intel.nix
  #       ../modules/programs/kitty.nix
  #       home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #       }
  #     ];
  #   };
  #
  # # MacBook8,1 "Core M" 1.2 12" (2012)
  # BodBookIntel =
  #   let
  #     inherit (systemConfig "x86_64-darwin") system pkgs stable;
  #   in
  #   darwin.lib.darwinSystem {
  #     inherit system;
  #     specialArgs = { inherit inputs system pkgs stable vars; };
  #     modules = [
  #       ./darwin-configuration.nix
  #       ./intel.nix
  #       ../modules/programs/kitty.nix
  #       home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #       }
  #     ];
  #   };
  #

  # MacBookPro16,1 M2 16" (2023)
  MacBookApple =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs stable;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs
          stable
          vars
          ;
      };
      modules = [
        ./darwin-configuration.nix
        ./apple.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
