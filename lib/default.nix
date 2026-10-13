{
  nixpkgs,
  darwin,
  flake-utils,
  agent-skills,
  ...
}@inputs:
let
  inherit (nixpkgs) lib;
in
rec {
  inherit (lib) optional optionals optionalAttrs;
  isDarwin = system: lib.hasSuffix "darwin" system;
  discoverPackages = import ./discoverPackages.nix { inherit lib; };

  pkgsWithOverlay =
    system: overlay:
    import nixpkgs {
      overlays = [ overlay ];
      inherit system;
    };

  mkCapabilityModule =
    {
      lib,
      name,
      default ? true,
    }:
    moduleBody:
    { config, ... }:
    let
      cfg = config.my.capabilities.${name};
    in
    {
      options.my.capabilities.${name}.enable = lib.mkOption {
        type = lib.types.bool;
        default = default;
        description = "Enable the ${name} capability.";
      };

      config = lib.mkIf cfg.enable moduleBody;
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
      specialArgs = {
        inherit system;
      }
      // _commonSpecialArgs
      // _specialArgs;
      modules =
        lib.optionals _home-manager.enable [
          homeFunc
          {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = ".bak";
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit system;
              inherit agent-skills;
            }
            // _commonSpecialArgs;
            # Import Home Manager modules only once per user to avoid
            # duplicate option declarations (e.g. programs.dank-material-shell.*).
            home-manager.users.${_username}.imports = _home-manager.modules;
          }
        ]
        ++ _modules
        ++ _extraConfig;
    };
}
