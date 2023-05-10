{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    awscli2
    coreutils
    github-cli
    wget
    ripgrep
    htop
    unar
    python3
    file
    feh
    jq
    killall
    fd
    nix-prefetch-git
    comma
    manix
    binutils
    act
    element-desktop
    hexyl
    pcalc
    cargo-flamegraph
    exa
  ];
}
