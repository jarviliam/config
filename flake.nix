{
  description = "Dotfile management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil-language-server.url = "github:oxalica/nil";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
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
      ghostty,
      sops-nix,
      llm-agents,
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
          nix-index-database
          sops-nix
          ;
      };
    in
    rec {
      packages = lib.packagesFromOverlay self.overlays.default;
      inherit lib;
      overlays.default = import ./pkgs/import.nix {
        inherit
          neovim-nightly-overlay
          nil-language-server
          ghostty
          llm-agents
          ;
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
              { pkgs, ... }:
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
        lab = lib.createSystem profiles.lab {
          system = "x86_64-linux";
          modules = [
            ./hosts/lab/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        workbook = lib.createSystem profiles.liam-work {
          system = "aarch64-darwin";
        };
      };
    };
}
