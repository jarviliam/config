{
  description = "Dotfile management";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ivar-nixpkgs-yabai-5_0_1.url = "github:IvarWithoutBones/nixpkgs?rev=161530fa3434ea801419a8ca33dcd97ffb8e6fee";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, darwin, home-manager, ivar-nixpkgs-yabai-5_0_1, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      commonDarwinConfig = [
        ./darwin
        home-manager.darwinModules.home-manager
      ];
    in
    {
      darwinConfigurations = {
        workbook = darwinSystem {
          system = "aarch64-darwin";
          modules = commonDarwinConfig ++ [
            ({ pkgs, ... }: {
              networking.hostname = "IITPC22-0029";
              nixpkgs.overlays = with inputs; [
                # TODO: Move back to official pkg once this is merged
                #       https://github.com/NixOS/nixpkgs/pull/203504
                (self: super: {
                  yabai-5_0_1 = (import ivar-nixpkgs-yabai-5_0_1 { inherit system; }).yabai;
                })
              ];
              users.users.liam-work.home = "/Users/liam.jarvis";
              home-manager = {
                useGlobalPkgs = true;
                users.liam-work = [ import (./.+ "/common/home.nix") ];
                sharedModules = [ nix-index-database.hmModules.nix-index ];
              };
            })
          ];
        };
      };
    };
}

