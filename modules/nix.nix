{ pkgs, nixpkgs, username, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = nixpkgs;

    gc = {
      automatic = true;
      interval.Day = 7; # Hours, minutes
      options = "--delete-older-than 7d";
    };
    settings = rec {
      auto-optimise-store = true;
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" username ];
      allowed-users = trusted-users;
    };
  };
  programs.nix-index.enable = true;
}
