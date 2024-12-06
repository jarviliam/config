{
  pkgs,
  nixpkgs,
  username,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = nixpkgs;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = rec {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        username
      ];
      allowed-users = trusted-users;
    };

    optimise.automatic = true;
  };
  programs.nix-index.enable = true;
}
