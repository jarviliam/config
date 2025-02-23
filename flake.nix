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
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil-language-server.url = "github:oxalica/nil";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      darwin,
      home-manager,
      nix-index-database,
      nil-language-server,
      neovim-nightly-overlay,
      ...
    }:
    let
      lib = import ./lib.nix {
        inherit
          nixpkgs
          home-manager
          darwin
          flake-utils
          ;
      };
      profiles = import ./profiles.nix {
        inherit
          self
          nixpkgs
          lib
          nix-index-database
          ;
      };
    in
    {
      packages = lib.packagesFromOverlay self.overlays.default;
      inherit lib;

      overlays.default = final: prev: {
        inherit nil-language-server;
        inherit neovim-nightly-overlay;
        vtsls = final.callPackage ./home-manager/vtsls.nix { };
      };

      nixosConfigurations = {
        nixtop = lib.createSystem profiles.liam-linux {
          system = "x86_64-linux";
          modules = [
            ./modules/linux/hardware/nixos-laptop.nix
            ./modules/linux/system.nix
          ];
          commonSpecialArgs = {
            hostname = "nixos";
          };
        };
        nixbox = lib.createSystem profiles.liam-linux {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixbox/configuration.nix
            ./modules/linux/system.nix
            (
              { pkgs, lib, ... }:
              {
                environment.systemPackages = [
                  pkgs.sbctl
                ];
                # boot.loader.systemd-boot.enable = lib.mkForce false;
                # boot.lanzaboote = {
                #   enable = true;
                #   pkiBundle = "/var/lib/sbctl";
                # };
              }
            )
          ];
          commonSpecialArgs = {
            hostname = "nixos";
          };
        };
      };

      darwinConfigurations = {
        workbook = lib.createSystem profiles.liam-work {
          system = "aarch64-darwin";
        };
      };
    };
}
