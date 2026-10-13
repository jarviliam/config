{
  self,
  nixpkgs,
  sops-nix,
  nix-index-database,
  agent-skills,
  flakeLib,
}:
rec {
  stateVersion = "24.11";
  liam =
    let
      username = "liam.jarvis";
    in
    {
      inherit username;
      commonSpecialArgs = {
        inherit
          username
          nixpkgs
          nix-index-database
          sops-nix
          ;
      };
      modules = [
        ./secrets/default.nix
        ./modules/nix.nix
      ];
      home-manager = {
        enable = true;
        inherit username;
        modules = [
          ./home-manager/default.nix
          ./home-manager/packages.nix
          ./modules/dev/git.nix
          ./modules/dev/gitui.nix
          ./modules/dev/gh.nix
          ./modules/editor/neovim.nix
          ./modules/cli/zsh.nix
          ./modules/cli/direnv.nix
          ./modules/cli/zoxide.nix
          ./modules/cli/btop.nix
          ./modules/cli/pager.nix
          ./modules/cli/ripgrep.nix
          ./modules/cli/fzf.nix
          ./modules/cli/fd.nix
          ./home-manager/modules/bitwarden.nix
          ./modules/terminal/ghostty.nix
          ./modules/system/home.nix
          ./modules/dev/delta.nix
          ./modules/dev/go.nix
          ./modules/dev/dev-tools.nix
          ./modules/dev/nix-init.nix
          ./modules/dev/nix-tools.nix
          sops-nix.homeManagerModules.sops
          (
            { config, ... }:
            {
              sops = {
                age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
                defaultSopsFile = ./secrets/shared.yaml;
              };
            }
          )
        ];
        extraConfig = {
          home.stateVersion = stateVersion;
        };
      };
      extraConfig = {
        nixpkgs.overlays = [ self.overlays.default ];
      };
    };

  liam-linux =
    let
      username = "liam";
    in
    liam
    // {
      inherit username;
      modules = [
        sops-nix.nixosModules.sops
        ./hosts/modules/common.nix
        ./modules/linux/network.nix
        ./modules/linux/window.nix
      ]
      ++ liam.modules;
      home-manager = liam.home-manager // {
        inherit username;
        enable = true;
        modules = [
          ./home-manager/modules/firefox
          ./home-manager/modules/hyprland.nix
        ]
        ++ liam.home-manager.modules;
      };
      commonSpecialArgs = liam.commonSpecialArgs // {
        inherit username;
        flakePath = "/home/liam/.setup";
        homeDirectory = "/home/liam/";
        roles = [
          "dev"
          "graphical"
        ];
      };
      extraConfig = liam.extraConfig // {
        system.stateVersion = stateVersion;
      };
    };

  liam-work = liam // {
    username = "liam.jarvis";
    modules = [
      ./modules/darwin
      ./modules/darwin/homebrew.nix
    ]
    ++ liam.modules;
    home-manager = liam.home-manager // {
      modules = liam.home-manager.modules;
    };
    commonSpecialArgs = liam.commonSpecialArgs // {
      username = "liam.jarvis";
      flakePath = "/Users/liam.jarvis/.setup";
      homeDirectory = "/Users/liam.jarvis";
      roles = [
        "dev"
        "work"
      ];
    };
    extraConfig = liam.extraConfig;
  };

  lab =
    let
      username = "admin";
    in
    {
      inherit username;
      modules = [
        sops-nix.nixosModules.sops
        ./secrets/default.nix
      ];
      home-manager = {
        inherit username;
      };
      extraConfig = liam.extraConfig // {
        # system.stateVersion = stateVersion;
      };
      commonSpecialArgs = {
        inherit flakeLib;
      };
    };
  vm =
    let
      username = "liam";
    in
    {
      inherit username;
      modules = [
        sops-nix.nixosModules.sops
      ]
      ++ liam.modules;
      home-manager = liam.home-manager // {
        inherit username;
        modules = liam.home-manager.modules;
      };
      commonSpecialArgs = liam.commonSpecialArgs // {
        inherit username;
        flakePath = "/home/liam/.setup";
        homeDirectory = "/home/liam";
        roles = [
          "dev"
          "work"
        ];
      };
      extraConfig = liam.extraConfig;
    };
}
