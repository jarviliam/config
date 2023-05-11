{
  description = "Dotfile management";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
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
  outputs = { self, nixpkgs, darwin, home-manager, nix-index-database, ... }:
    let
      lib = import ./lib.nix {
        inherit nixpkgs home-manager darwin nix-index-database;
      };
      profiles = import ./profiles.nix
        {
          inherit self nixpkgs lib;
        };
      # commonDarwinConfig = [
      #   ./darwin
      #   home-manager.darwinModules.home-manager
      # ];
      # nixosModules = { user, host }: with inputs; [
      #   (./. + "/hosts/${host}/configuration.nix")
      #   home-manager.nixosModules.home-manager
      # ];
    in
    {
      inherit lib;
      nixosConfigurations = {
        # nixtop = nixpkgs.lib.nixosSystem
        #   {
        #     system = "x86_64-linux";
        #     modules = nixosModules {
        #       user = "liam";
        #       host = "nixtop";
        #     };
        #   };
      };
      darwinConfigurations = {
        workbook = lib.createSystem profiles.liam-work {
          system = "aarch64-darwin";
          # modules = commonDarwinConfig ++ [
          #   ({ pkgs, ... }: {
          #     nixpkgs.config.allowUnfree = true;
          #     users.users."liam.jarvis".home = "/Users/liam.jarvis";
          #     home-manager = {
          #       useGlobalPkgs = true;
          #       useUserPackages = true;
          #       users."liam.jarvis" = import (./. + "/hosts/workbook/home.nix");
          #       sharedModules = [ nix-index-database.hmModules.nix-index ];
          #     };
          #   })
          # ];
        };
      };
    };
}

