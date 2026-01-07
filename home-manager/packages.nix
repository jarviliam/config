{ pkgs, ... }:
let
  isDarwin = pkgs.stdenvNoCC.isDarwin;
  isLinux = pkgs.stdenvNoCC.isLinux;

  fonts = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.commit-mono
    source-code-pro
  ];

  python = with pkgs; [
    python312
    codespell
    pre-commit
    poetry
    pyright
    basedpyright
    ruff
    vtsls
  ];

  lua = with pkgs; [
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.tiktoken_core
    lua51Packages.busted
    lua53Packages.luacheck
    lua-language-server
    stylua
  ];

  cliUtils = with pkgs; [
    harper
    coreutils
    wget
    ripgrep
    awscli2
    ssm-session-manager-plugin
    # vectorcode
    prr
    htop
    unar
    file
    openssh
    jq
    yq
    jwt-cli
    fd
    nix-prefetch-git
    comma
    manix
    github-cli
    better-commits
    dwt1-shell-color-scripts
    qbittorrent
    neovim
    tree-sitter
    zine
    lazygit
    graphite-cli
    typescript-go
    uv
    typos-lsp

    tailscale-acl-combiner
  ];

  node = with pkgs; [
    # nodePackages.npm causes node build
    yarn
    pnpm
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    actionlint
    yamllint
    eslint_d
    marksman
    github-actions-languageserver
    prettierd
    nodePackages.bash-language-server
    yaml-language-server
  ];

  goPkg = with pkgs; [
    go
    gopls
    delve
    go-testfixtures
  ];

  nix = with pkgs; [
    nil-language-server
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    statix
  ];

  rust = with pkgs; [
    cargo
    rustfmt
    rustc
    clippy
    rust-analyzer
  ];

  cloud = with pkgs; [
    kubectl
    kubectx
    docker
    docker-compose
    terraform-ls
    tflint
  ];

  cmake = with pkgs; [
    cmake
    cmake-language-server
  ];

  db = with pkgs; [
    redis
    pgcli
  ];

  osSpecific =
    if isDarwin then
      with pkgs;
      [
        slack
        terraform
      ]
    else
      with pkgs;
      [
        gcr
        ghostty
        gcc
        todoist-electron
      ];
in
{
  home.packages =
    fonts ++ cliUtils ++ python ++ lua ++ node ++ goPkg ++ nix ++ rust ++ cloud ++ db ++ osSpecific;
}
