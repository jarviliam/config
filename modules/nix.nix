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
    gc.automatic = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false; # Gets pretty annoying while working on a flake
      auto-optimise-store = !pkgs.stdenvNoCC.isDarwin;
    };
  };
}
