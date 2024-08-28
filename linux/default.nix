{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  zig,
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
      overlays = [ zig.overlays.default ];
    };
    stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  # zygizo-one
  ZygizoOne =
    let
      inherit (systemConfig "x86_64-linux") system pkgs stable;
    in
      home-manager.lib.homeManagerConfiguration  {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              system
              pkgs
              stable
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

