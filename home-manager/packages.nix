{ pkgs
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
    neovim
    file
    nodePackages.npm
    source-code-pro
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
    neofetch
    nodejs
    openssh
    ripgrep
    jq
    yq
    qmk
    killall
    fd
    nix-prefetch-git
    comma
    manix
    qbittorrent
  ] ++ [
    docker
    docker-compose
    slack
    gettext
    terraform-ls
    # tfenv
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
    ruff

    lua53Packages.luacheck
    # Node
    # prettierd
    terraform # look into tfenv porting
    yamllint

    stylua
    # Go
    go
    gotools
    gopls
    delve

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
    nixfmt
    nixpkgs-fmt
    statix

    # Rust
    cargo
    rustfmt
    rustc
    clippy
    rust-analyzer

    vimPlugins.nvim-treesitter.withAllGrammars
  ];
}
