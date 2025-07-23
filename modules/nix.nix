{
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.latest;
    gc.automatic = true;
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false; # Gets pretty annoying while working on a flake
      auto-optimise-store = !pkgs.stdenvNoCC.isDarwin;
    };
  };
}
