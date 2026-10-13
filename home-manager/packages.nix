{ pkgs, ... }:
let
  isDarwin = pkgs.stdenvNoCC.hostPlatform.isDarwin;

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
    gitspice
    harper
    coreutils
    wget
    ripgrep
    k9s
    awscli2
    ssm-session-manager-plugin
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
    ob-hd
    github-cli
    dwt1-shell-color-scripts
    qbittorrent
    neovim
    tree-sitter
    zine
    lazygit
    typescript
    uv
    typos-lsp
    markdownlint-cli2
    imhex

    tailscale-acl-combiner
    # llm-agents.amp
  ];

  node = with pkgs; [
    # nodePackages.npm causes node build
    yarn
    pnpm
    typescript-language-server
    vscode-langservers-extracted
    actionlint
    yamllint
    eslint_d
    marksman
    github-actions-languageserver
    prettierd
    bash-language-server
    yaml-language-server
    commitlint
  ];

  goPkg = with pkgs; [
    go
    gopls
    delve
    go-testfixtures
    golangci-lint
  ];

  nix = with pkgs; [
    nil-language-server
    nixd
    nixfmt
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
        # gcr
        gcc
        todoist-electron
        flameshot
        zmx
        obsidian
      ];
in
{
  home.packages =
    fonts ++ cliUtils ++ python ++ lua ++ node ++ goPkg ++ nix ++ rust ++ cloud ++ db ++ osSpecific;
}
