{ pkgs
, nixpkgs
, ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = nixpkgs;

    gc.automatic = true;

    settings = rec {
      auto-optimise-store = true;
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
    programs.nix-index.enable = true;
    programs.nix-index.enableZshIntegration = true;
}
