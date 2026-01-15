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
  # Overlay to disable tests for cachix
  cachixNoTestsOverlay = (
    final: prev: {
      cachix =
        let
          # In most nixpkgs, pkgs.cachix is the Haskell package derivation.
          # But if it's not there, fall back to haskellPackages.cachix.
          base = if prev ? cachix then prev.cachix else prev.haskellPackages.cachix;
        in
        base.overrideAttrs (old: {
          # Disable the test phases
          doCheck = false;
          doInstallCheck = false;
        });
    }
  );
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ cachixNoTestsOverlay ];
    };
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [ cachixNoTestsOverlay ];
    };
  };
in
{
  BodBook =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs unstable;
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
        ./bodbook-configuration.nix
        ./intel.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              system
              pkgs
              unstable
              vars
              ;
          };
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
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              system
              pkgs
              unstable
              vars
              ;
          };
        }
      ];
    };
}
