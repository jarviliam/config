{ neovim-nightly-overlay, nil-language-server, ... }:
final: prev:
let
  pkgs = final;
in
with pkgs;
{
  neovim = neovim-nightly-overlay.packages.${system}.default;

  zmx = final.callPackage ./zmx.nix { };

  nil-language-server = nil-language-server.packages.${system}.nil;

  vtsls = final.callPackage ./vtsls.nix { };

  release-please = final.callPackage ./release-please.nix { };

  github-actions-languageserver = final.callPackage ./gha.nix { };

  go-testfixtures = final.callPackage ./testfixtures.nix { };

  tailscale-acl-combiner = final.callPackage ./tailscale-acl-combiner.nix { };

  bitwarden-cli = prev.bitwarden-cli.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.llvmPackages_18.stdenv.cc ];
    stdenv = prev.llvmPackages_18.stdenv;
  });
}
