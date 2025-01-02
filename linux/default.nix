{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
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
  # frodes-ros-machine
  Ros =
    let
      inherit (systemConfig "aarch64-linux") system pkgs unstable;
    in
      home-manager.lib.homeManagerConfiguration  {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              system
              pkgs
              unstable
              vars
              ;
          };
          modules = [ 
            ./linux-configuration.nix
            # home-manager.nixosModules.home-manager {
            #   home-manager.useGlobalPkgs = false;
            #   home-manager.useUserPackages = true;
            # }
          ];
        };
  
  # zygizo-one
  ZygizoOne =
    let
      inherit (systemConfig "x86_64-linux") system pkgs unstable;
    in
      home-manager.lib.homeManagerConfiguration  {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              system
              pkgs
              unstable
              vars
              ;
          };
          modules = [ 
            ./linux-configuration.nix
            # home-manager.nixosModules.home-manager {
            #   home-manager.useGlobalPkgs = false;
            #   home-manager.useUserPackages = true;
            # }
          ];
        };
}

