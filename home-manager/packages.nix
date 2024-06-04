{ pkgs, lib, nixstaging, ... }:
let
  py312 = pkgs.python312.overrideAttrs
    (old: {
      version = "3.12.3";
    });
  # nixpkgs_staging = import <nixpkgs_staging> { };
  mypython312 = pkgs.python312Full.override {
    self = pkgs.python312Full;
    version = "3.12.3";
    pythonAttr = "python312Full";
    bluezSupport = false;
  };
  efm = pkgs.efm-langserver.overrideAttrs (old: {
    version = "0.0.50";
    src = pkgs.fetchFromGitHub {
      owner = "mattn";
      repo = "efm-langserver";
      rev = "v0.0.50";
      sha256 = "sha256-3WnMEkDa1boExyOg30wiFqs1Nw/zMtBqoUmtjluTQ0Y=";
    };
    vendorHash = lib.fakeSha256;
  });
in
{
  home.packages = with pkgs;
    [
      bazel
      bazel-gazelle
      emacs
      lua
      luajitPackages.luarocks-nix
      awscli2
      zk
      coreutils
      github-cli
      wget
      yazi
      ripgrep
      htop
      unar
      neovim
      file
      nodePackages.npm
      source-code-pro
      (nerdfonts.override {
        fonts =
          [
            "FiraCode"
            "JetBrainsMono"
            "Iosevka"
            "FantasqueSansMono"
            "Hack"
            "IntelOneMono"
          ];
      })
      neofetch
      nodejs
      openssh
      ripgrep
      jq
      yq
      jwt-cli
      kubectl
      # qmk
      killall
      fd
      nix-prefetch-git
      # efm
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
      argocd
    ] ++ [
      # Python
      py312
      # python312Packages.virtualenv
      # python312Packages.pip
      cloud-custodian
      codespell
      pre-commit
      poetry
      black
      isort
      nodePackages_latest.pyright
      ruff
      ruff-lsp

      lua53Packages.luacheck
      lua-language-server
      # Node
      actionlint
      prettierd
      terraform # look into tfenv porting
      yamllint
      yarn
      nodePackages.typescript-language-server

      stylua
      # Go
      go_1_21
      gotools
      gopls
      delve

      yaml-language-server # YAML
      nodePackages.typescript-language-server # Typescript/javascript
      nodePackages.vscode-langservers-extracted # JSON/HTML

      # sumneko-lua-language-server # Lua
      cmake-language-server # CMake

      # C/C++
      # nixstaging.clang-tools
      # staging.clang
      # clang
      # pkg-config
      cmake
      # meson
      # llvm
      # libcxxabi

      # Bash
      shellcheck
      nodePackages.bash-language-server

      # release-please
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
      redis
      pgcli

      # clamav
      # zathura
    ];
}
