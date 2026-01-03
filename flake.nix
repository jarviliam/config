{
  description = "Dotfile management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-master.url = "github:nixos/nixpkgs/master"; 
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
      nix-master,
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
    rec {
      packages = lib.packagesFromOverlay self.overlays.default;
      inherit lib;

      overlays.default =
        final: prev:
        let
          system =
            final.stdenvNoCC.hostPlatform.system
              or (throw "Unsupported platform ${final.stdenvNoCC.hostPlatform.system}");
        in
        {
          neovim = neovim-nightly-overlay.packages.${system}.default;
	  udevil = nix-master.legacyPackages.${system}.udevil;
	  polybar = nix-master.legacyPackages.${system}.polybar;
          nil-language-server = nil-language-server.packages.${system}.nil;
          vtsls = final.callPackage ./home-manager/vtsls.nix { };
          release-please = final.callPackage ./home-manager/release-please.nix { };
          github-actions-languageserver = final.callPackage ./home-manager/gha.nix { };
          better-commits = final.callPackage ./home-manager/bettercommit.nix { };
          go-testfixtures = final.callPackage ./home-manager/testfixtures.nix { };
          bitwarden-cli = prev.bitwarden-cli.overrideAttrs (oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.llvmPackages_18.stdenv.cc ];
            stdenv = prev.llvmPackages_18.stdenv;
          });
          bugwarrior-dev = prev.python312Packages.bugwarrior.overrideAttrs (
            finalAttrs: prevAttrs: {
              version = "develop";

              # Fetching from repository instead of published version in pypi.
              src = final.fetchFromGitHub {
                owner = "GothenburgBitFactory";
                repo = "bugwarrior";
                rev = "7ea84aebf3fb8dba5ad09608c02ef600fded5119";
                sha256 = "sha256-MaZAG+vp++Wfhj3SW3S4q7tcmR4ZtM5FOJ+/2Wz0zDk=";
              };

              # Adding dependencies that were added in new versions.
              propagatedBuildInputs =
                prevAttrs.propagatedBuildInputs ++ (with prev; [ python312Packages.pydantic ]);
            }
          );
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
        snowball = lib.createSystem profiles.vm {
          system = "x86_64-linux";
          modules = [
            ./hosts/snowball/configuration.nix
          ];
          home-manager = {
            modules = [
              ./home-manager/modules/bug-warrior.nix
            ];
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
