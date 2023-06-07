{ pkgs, nixpkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = nixpkgs;

    # gc.user = "root";
    gc = {
      automatic = true;
      interval.Day = 7; # Hours, minutes
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  programs.nix-index.enable = true;
}
