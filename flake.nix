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
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ivar-nixpkgs-yabai-5_0_1, nix-index-database, ... }:
    let
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
              # networking.hostname = "IITPC22-0029";
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = with inputs; [
                # TODO: Move back to official pkg once this is merged
                #       https://github.com/NixOS/nixpkgs/pull/203504
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

