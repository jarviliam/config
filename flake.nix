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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ivar-nixpkgs-yabai-5_0_1, nix-index-database, ... }:
    let
      lib = import ./lib.nix {
        inherit nixpkgs;
      };
      commonDarwinConfig = [
        ./darwin
        home-manager.darwinModules.home-manager
      ];
      nixosModules = { user, host }: with inputs; [
        (./. + "/hosts/${host}/configuration.nix")
        home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations = {
        nixtop = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = nixosModules {
              user = "liam";
              host = "nixtop";
            };
          };
      };
      darwinConfigurations = {
        workbook = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          # nixpkgs.config.allowUnfree = true;
          modules = commonDarwinConfig ++ [
            ({ pkgs, ... }: {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = with inputs; [
                (self: super: {
                  yabai-5_0_1 = (import ivar-nixpkgs-yabai-5_0_1 { inherit system; }).yabai;
                })
              ];
              users.users."liam.jarvis".home = "/Users/liam.jarvis";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."liam.jarvis" = import (./. + "/hosts/workbook/home.nix");
                sharedModules = [ nix-index-database.hmModules.nix-index ];
              };
            })
          ];
        };
      };
    };
}

