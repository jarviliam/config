{
  nixpkgs,
  darwin,
  flake-utils,
  ...
}@inputs:
let
  inherit (nixpkgs) lib;
in
rec {
  inherit (lib) optional optionals optionalAttrs;
  isDarwin = system: lib.hasSuffix "darwin" system;

  pkgsWithOverlay =
    system: overlay:
    import nixpkgs {
      overlays = [ overlay ];
      inherit system;
    };

  packagesFromOverlay =
    overlay:
    {
      inherit
        (flake-utils.lib.eachSystem lib.platforms.all (system: {
          packages = pkgsWithOverlay system overlay;
        }))
        packages
        ;
    }
    .packages;

  createSystem =
    profile:
    {
      system,
      modules ? [ ],
      home-manager ? { },
      commonSpecialArgs ? { },
      specialArgs ? { },
      extraConfig ? { },
      ...
    }:
    let
      _username = lib.optionalString _home-manager.enable (
        home-manager.username or profile.home-manager.username
      );
      _specialArgs = lib.mergeAttrs specialArgs (profile.specialArgs or { });
      _commonSpecialArgs = lib.mergeAttrs commonSpecialArgs (profile.commonSpecialArgs or { });
      _extraConfig = lib.toList (lib.mergeAttrs (profile.extraConfig or { }) extraConfig);
      _modules = modules ++ (profile.modules or [ ]);
      _home-manager = {
        enable = profile.home-manager.enable or false;
        modules =
          (profile.home-manager.modules or [ ])
          ++ (home-manager.modules or [ ])
          ++ lib.toList (
            lib.mergeAttrs (profile.home-manager.extraConfig or { }) (home-manager.extraConfig or { })
          );
      };
      systemFunc = if isDarwin system then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
      homeFunc =
        if isDarwin system then
          inputs.home-manager.darwinModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
    in
    systemFunc {
      inherit system;
      specialArgs = { inherit system; } // _commonSpecialArgs // _specialArgs;
      modules =
        lib.optionals _home-manager.enable [
          homeFunc
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit system;
            } // _commonSpecialArgs;
            home-manager.sharedModules = _home-manager.modules;
            home-manager.users.${_username}.imports = _home-manager.modules;
          }
        ]
        ++ _modules
        ++ _extraConfig;
    };
}
