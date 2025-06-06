{ pkgs, ... }:
let
  isDarwin = pkgs.stdenvNoCC.isDarwin;
  isLinux = pkgs.stdenvNoCC.isLinux;
in
{
  home.packages =
    with pkgs;
    [
      zine
      # pyenv
      lua51Packages.lua
      lua51Packages.luarocks
      lua51Packages.tiktoken_core
      lua51Packages.busted
      # awscli2
      coreutils
      github-cli
      wget
      ripgrep
      htop
      unar
      neovim
      file
      zig
      zls
      nodePackages.npm
      source-code-pro
      clang-tools
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.commit-mono
      nodejs
      openssh
      ripgrep
      jq
      yq
      jwt-cli
      kubectl
      fd
      nix-prefetch-git
      comma
      manix
      qbittorrent
      eslint_d
      dwt1-shell-color-scripts
      better-commits
      taskwarrior3
    ]
    ++ isDarwin [
      slack
      terraform
    ]
    ++ isLinux [
      zathura
      qmk
    ]
    ++ [
      docker
      docker-compose
      gettext
      terraform-ls
      tflint
      kubectx
      lazygit
    ]
    ++ [
      # Python
      python312
      codespell
      pre-commit
      (poetry.withPlugins (ps: with ps; [ poetry-plugin-export ]))
      pyright
      basedpyright
      ruff
      vtsls

      github-actions-languageserver
      marksman

      lua53Packages.luacheck
      lua-language-server

      # Node
      actionlint
      prettierd
      yamllint
      yarn
      pnpm
      nodePackages.typescript-language-server
      stylua

      # Go
      go
      gotools
      gopls
      delve
      golangci-lint

      yaml-language-server # YAML
      nodePackages.typescript-language-server # Typescript/javascript
      nodePackages.vscode-langservers-extracted # JSON/HTML

      cmake-language-server # CMake
      cmake

      # Bash
      shellcheck
      nodePackages.bash-language-server

      # Nix
      nil-language-server
      nixfmt-rfc-style
      nixpkgs-fmt
      statix

      # Rust
      cargo
      rustfmt
      rustc
      clippy
      rust-analyzer

      redis
      pgcli
      bitwarden-cli
    ];
}
