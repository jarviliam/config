{ self
, nixpkgs
, lib
,
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
        inherit username nixpkgs;
      };
      modules = [ ./modules/nix.nix ];
      home-manager = {
        enable = true;
        inherit username;
        modules = [
          ./home-manager/default.nix
          ./home-manager/packages.nix
          ./home-manager/modules/git.nix
          ./home-manager/modules/zsh.nix
          ./home-manager/modules/bat.nix
          ./home-manager/modules/fzf.nix
          ./home-manager/modules/tmux.nix
          ./home-manager/modules/wezterm.nix
          ./home-manager/modules/nvim
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
        ./modules/linux/network.nix
        ./modules/linux/window.nix
      ] ++ liam.modules;
      home-manager = liam.home-manager // {
        inherit username;
        enable = true;
        modules = [
          ./home-manager/modules/linux/x.nix
          ./home-manager/modules/firefox
          ./home-manager/modules/linux/poly.nix
        ] ++ liam.home-manager.modules;
      };
      commonSpecialArgs = liam.commonSpecialArgs // {
        inherit username;
        flakePath = "/home/liam.jarvis/nix_dot";
      };
      extraConfig = liam.extraConfig // {
        system.stateVersion = stateVersion;
      };
    };

  liam-work = liam // {
    username = "liam.jarvis";
    modules = [
      ./modules/darwin
      ./modules/darwin/yabai
      ./modules/darwin/skhd
    ] ++ liam.modules;
    home-manager = liam.home-manager // {
      modules = liam.home-manager.modules;
    };
    commonSpecialArgs = liam.commonSpecialArgs // {
      username = "liam.jarvis";
      flakePath = "/Users/liam.jarvis/nix_dot";
    };
    extraConfig = liam.extraConfig;
  };
}
