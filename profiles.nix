{ self, nixpkgs, lib }: rec {
  liam =
    let
      username = "liam"; in
    {
      inherit username;
      modules = [ ./modules/nix.nix ];

      home-manager = {
        enable = true;
        inherit username;
        modules = [
          ./home-manager/default.nix
          ./home-manager/packages.nix
          ./home-manager/modules/git.nix
          ./home-manager/modules/zsh.nix
          ./home-manager/modules/fzf.nix
        ];

        extraConfig = {
          home.stateVersion = "23.05";
        };
      };
    };
  liam-linux = liam // { };
  liam-work = liam // {
    modules = [ ./modules/darwin ./modules/darwin/yabai ./modules/darwin/skhd ] ++ liam.modules;

    home-manager = liam.home-manager // {
      enable = true;
      modules = [ ] ++ liam.home-manager.modules;
    };
  };
}
