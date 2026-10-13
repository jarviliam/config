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

  cliUtils = with pkgs; [
    coreutils
    wget
    k9s
    awscli2
    ssm-session-manager-plugin
    htop
    unar
    file
    openssh
    comma
    ob-hd
    dwt1-shell-color-scripts
    qbittorrent
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
  ];

  cmake = with pkgs; [
    cmake
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
  home.packages = fonts ++ cliUtils ++ python ++ node ++ rust ++ cloud ++ osSpecific;
}
