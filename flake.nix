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
        neovim =
          neovim-nightly-overlay.packages.${
            final.stdenvNoCC.hostPlatform.system
              or (throw "Unsupported platform ${final.stdenvNoCC.hostPlatform.system}")
          }.default;
        nil-language-server =
          nil-language-server.packages.${
            final.stdenvNoCC.hostPlatform.system
              or (throw "Unsupported platform ${final.stdenvNoCC.hostPlatform.system}")
          }.nil;
        vtsls = final.callPackage ./home-manager/vtsls.nix { };
        better-commits = final.callPackage ./home-manager/bettercommit.nix { };
        bitwarden-cli = prev.bitwarden-cli.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.llvmPackages_18.stdenv.cc ];
          stdenv = prev.llvmPackages_18.stdenv;
        });
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
