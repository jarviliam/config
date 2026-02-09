{ pkgs, ... }:
let
  isDarwin = pkgs.stdenvNoCC.isDarwin;
  isLinux = pkgs.stdenvNoCC.isLinux;

  gitReview = pkgs.writeShellScriptBin "git-review" ''
    #!/usr/bin/env bash
    (
      TARGET_DIR=''${REVIEW_WORKTREE/#\~/$HOME}
      if [ -n "$TARGET_DIR" ]; then
        cd "$TARGET_DIR" || exit
      fi

      YELLOW="\e[33m"
      RESET="\e[0m"
      
      # 1. Selection Function using fzf
      sel() {
        # Fetch PRs with metadata, format for fzf, and pick one
        local choice
        choice=$(gh pr list --search "review-requested:@me" \
          --json number,title,headRefName,baseRefName \
          --template '{{range .}}#{{.number}} | {{.title}} | {{.headRefName}} | {{.baseRefName}}{{"\n"}}{{end}}' | \
          fzf --ansi --header "Select PR to Review" --prompt "PR > ")

        if [ -n "$choice" ]; then
          # Extract branch (3rd column) and base (4th column) from the selection
          local target_branch=$(echo "$choice" | cut -d'|' -f3 | xargs)
          local target_base=$(echo "$choice" | cut -d'|' -f4 | xargs)
          # Restart this script with the selected branch and base
          exec git-review "$target_branch" "origin/$target_base"
        fi
      }

      export branch="''${1#origin/}"
      export base="''${2:-origin/master}"

      # If no branch is provided as an argument, immediately trigger selection
      if [ -z "$1" ]; then
        sel
      fi

      git switch -d "origin/$branch"
      echo -e "Reviewing $YELLOW$branch$RESET -> $base"

        d() { git diff --merge-base $base --stat $@ ; }
        l() { git log "$base..HEAD" --oneline $@ ; }
        r() { 
          nvim -c "GcLog ''${base}..HEAD" \
           -c "clast" \
           "$@" ;}

        l  # display log

        r
        declare -fx d l r sel
        exec zsh -i
    )
  '';

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
    opencode
    gitReview
    harper
    coreutils
    wget
    ripgrep
    k9s
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
