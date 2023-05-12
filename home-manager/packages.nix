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
    jetbrains-mono
    neovim
    file
    nodePackages.npm
    neofetch
    nodejs
    openssh
    ripgrep
    jq
    yq
    killall
    fd
    nix-prefetch-git
    comma
    manix
  ] ++ [
    docker
    docker-compose
    slack
    gettext
    terraform-ls
    tflint
    kubectx
    lazydocker
  ] ++ [
    # Python
    python311
    python311Packages.virtualenv
    python311Packages.pip
    codespell
    pre-commit
    poetry
    black
    isort
    nodePackages_latest.pyright

    # Node

    # Go
    go
    gotools
    gopls

    yaml-language-server # YAML
    nodePackages.typescript-language-server # Typescript/javascript
    nodePackages.vscode-langservers-extracted # JSON/HTML

    sumneko-lua-language-server # Lua
    cmake-language-server # CMake

    # C/C++
    clang-tools
    clang

    # Bash
    shellcheck
    nodePackages.bash-language-server

    # Nix
    # rnix-lsp
    nil-language-server
    nixpkgs-fmt
    statix

    # Rust
    cargo
    rustfmt
    rustc
    clippy
    rust-analyzer
  ];
}
