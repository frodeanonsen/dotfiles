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
  nixpkgs-unstable,
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
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  BodBook =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs stable;
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
        ./bodbook-configuration.nix
        ./intel.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  # MacBookPro16,1 M2 16" (2023)
  MacBookApple =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs unstable;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          system
          pkgs
          unstable
          vars
          ;
      };
      modules = [
        ./zygbook-configuration.nix
        ./apple.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
