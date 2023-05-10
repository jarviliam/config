{ nixpkgs, ... }@inputs:
let inherit (nixpkgs) lib;
in
rec {
  inherit (lib) optional optionals optionalAttrs;
  isDarwin = system: lib.hasSuffix "darwin" system;

  createSystem = profile: { system, modules ? [ ], home-manager ? { }, ... }:
    let
      _username = lib.optionalString _home-manager.enable (profile.home-manager.username);
      _modules = modules ++ (profile.modules or [ ]);
      _home-manager = {
        enable = if (profile.home-manager.enable) then true else false;
        modules = profile.home-manager.modules or [ ];
      };
      systemFunc = if (isDarwin system) then nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
      homeFunc = if (isDarwin system) then inputs.home-manager.darwinModule else inputs.home-manager.nixosModules.home-manager;
    in
    systemFunc {
      inherit system;
      modules = lib.optionals _home-manager.enable [
        homeFunc
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ _home-manager.modules nix-index-database.hmModules.nix-index ];
          home-manager.users.${_username}.imports = _home-manager.modules;
        }
      ] ++ _modules;
    };
}
