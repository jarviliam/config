{ pkgs, ... }: {
  home.packages = with pkgs; [
    cachix
    deadnix
    flake-checker
    nix-output-monitor
    nix-tree
    nurl
    statix
    manix

    nixd
    nixfmt
    nixpkgs-fmt
    nil-language-server
  ];
}
