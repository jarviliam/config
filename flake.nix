{
  description = "Dotfile management";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixstaging.url = "github:nixos/nixpkgs/staging";
    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "path:/Users/liam.jarvis/Coding/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      # url = "github:wegank/nix-darwin/mddoc-remove";
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:pta2002/nixvim";
      # url = "path:/Users/liam.jarvis/Coding/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = { url = "github:nix-community/NUR"; };
    nil-language-server.url = "github:oxalica/nil";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = { self, nixpkgs, nixstaging, flake-utils, darwin, home-manager
    , nix-index-database, nil-language-server, nur, nixvim
    , neovim-nightly-overlay, ... }:
    let
      lib = import ./lib.nix {
        inherit nixpkgs home-manager darwin flake-utils nix-index-database;
      };
      profiles = import ./profiles.nix { inherit self nixpkgs lib; };
    in {
      packages = lib.packagesFromOverlay self.overlays.default;
      inherit lib;

      overlays.default = final: prev: {
        # nil-language-server = nil-language-server.packages.aarch64-darwin.nil;
        nil-language-server = nil-language-server.packages.${
            final.stdenvNoCC.hostPlatform.system or (throw
              "Unsupported platform ${final.stdenvNoCC.hostPlatform.system}")
          }.nil;
        prettierd = final.callPackage ./home-manager/prettierd.nix { };
        neomutt = prev.neomutt.overrideAttrs (oldAttrs: { doCheck = false; });
        staging = nixstaging.legacyPackages.aarch64-darwin;
        # release-please = prev.callPackage ./release-please.nix;
      };

      nixosConfigurations = {
        nixtop = lib.createSystem profiles.liam-linux {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            ./modules/linux/hardware/nixos-laptop.nix
            ./modules/linux/system.nix
          ];
          commonSpecialArgs = { hostname = "nixos"; };
        };
      };
      darwinConfigurations = {
        workbook = lib.createSystem profiles.liam-work {
          system = "aarch64-darwin";
          commonSpecialArgs = { inherit nixvim nixstaging; };
          modules = [{
            nixpkgs.overlays = [ nur.overlay ]
              ++ [ neovim-nightly-overlay.overlays.default ];
          }];
        };
      };
    };
}
