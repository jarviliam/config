{ pkgs, lib, ... }:
let
  py312 = pkgs.python312.override {
    sourceVersion = {
      major = "3";
      minor = "12";
      patch = "5";
      suffix = "";
    };
    hash = "sha256-+oouEsXmILCfU+ZbzYdVDS5aHi4Ev4upkdzFUROHY5c=";
  };
  # nixpkgs_staging = import <nixpkgs_staging> { };
  mypython312 = pkgs.python312Full.override {
    self = pkgs.python312Full;
    version = "3.12.4";
    pythonAttr = "python312Full";
    bluezSupport = false;
  };
  pyenv = pkgs.pyenv.overrideAttrs (old: {
    version = "2.4.12";
    src = pkgs.fetchFromGitHub {
      owner = "pyenv";
      repo = "pyenv";
      rev = "refs/tags/v2.4.12";
      hash = "sha256-ZvXtDD9HKwOJiUpR8ThqyCHWyMFs46dIrOgPMNpuHrY=";
    };
  });
in
{
  home.packages =
    with pkgs;
    [
      emacs
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
      (nerdfonts.override {
        fonts = [
          "CommitMono"
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
          "FantasqueSansMono"
          "Hack"
          "IntelOneMono"
        ];
      })
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
    ]
    ++ lib.optionals pkgs.stdenvNoCC.isDarwin [
      slack
      terraform
      argocd
      # darwin.CF
      # darwin.Security
      # darwin.apple_sdk
      # clamav
      # release-please
    ]
    ++ lib.optionals pkgs.stdenvNoCC.isLinux [
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
      poetry
      pyright
      ruff
      ruff-lsp
      vtsls
      git-spice

      lua53Packages.luacheck
      lua-language-server
      # Node
      actionlint
      prettierd
      yamllint
      yarn
      nodePackages.typescript-language-server

      stylua
      sqlc
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
      # rnix-lsp
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
    ];
}
