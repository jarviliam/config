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
    coreutils
    wget
    ripgrep
    k9s
    awscli2
    ssm-session-manager-plugin
    htop
    unar
    file
    openssh
    fd
    comma
    ob-hd
    dwt1-shell-color-scripts
    qbittorrent
    neovim
    tree-sitter
    typescript
    uv
    markdownlint-cli2
    imhex
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
        gcc
        todoist-electron
        flameshot
        zmx
        obsidian
      ];
in
{
  home.packages = fonts ++ cliUtils ++ python ++ lua ++ node ++ rust ++ cloud ++ osSpecific;
}
