{ self, nixpkgs, lib, nixvim }: rec {
  liam =
    let
      username = "liam.jarvis"; in
    {
      inherit username;

      commonSpecialArgs =
        {
          inherit username nixpkgs nixvim;
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
          home.stateVersion = "23.05";
        };
      };
      extraConfig = {
        nixpkgs.overlays = [ self.overlays.default ];
      };
    };
  liam-linux = liam // {
    username = "liam";
    modules = [ ./modules/linux/system.nix ] ++ liam.modules;
    home-manager = liam.home-manager // {
      modules = liam.home-manager.modules;
    };
    commonSpecialArgs = liam.commonSpecialArgs;
  };

  liam-work = liam // {
    username = "liam.jarvis";
    modules = [ ./modules/darwin ./modules/darwin/yabai ./modules/darwin/skhd ] ++ liam.modules;

    home-manager = liam.home-manager // {
      modules = liam.home-manager.modules;
    };
    commonSpecialArgs = liam.commonSpecialArgs;
  };
}
