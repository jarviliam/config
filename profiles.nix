{ self, nixpkgs, lib, nixvim }: rec {
  liam =
    let
      username = "liam"; in
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
          ./home-manager/modules/firefox
        ];

        extraConfig = {
          home.stateVersion = "22.11";
        };
      };
      extraConfig = {
        nixpkgs.overlays = [ self.overlays.default ];
      };
    };
  liam-linux = liam // {
    username = "liam";
    modules = [ ./modules/linux/network.nix ./modules/linux/window.nix ] ++ liam.modules;
    home-manager = liam.home-manager // {
      enable = true;
      modules = [./home-manager/modules/linux/x.nix
        ./home-manager/modules/firefox
      ]++liam.home-manager.modules;
    };
    commonSpecialArgs = liam.commonSpecialArgs;
    extraConfig = {
        system.stateVersion = "22.11"; # Did you read the comment?
    };
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
