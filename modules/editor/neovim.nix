{
  config,
  flakePath,
  pkgs,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home-manager/modules/nvim/config";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages =
    with pkgs;
    [
      neovim
      gopls

      lua-language-server
      emmylua-ls
      emmylua-check
      stylua

      bash-language-server
      commitlint-rs
      crates-lsp
      docker-compose-language-service
      dockerfile-language-server
      terraform-ls
      cmake-language-server
      nixd

      tflint
      typescript-language-server
      vscode-langservers-extracted
      actionlint
      marksman
      github-actions-languageserver
      prettierd
      bash-language-server
      yaml-language-server
      yamllint
      eslint_d
    ]
    ++ [
      luajitPackages.busted
      luajitPackages.luarocks
      luajitPackages.nlua
    ];

  xdg.configFile = {
    "clangd/config.yaml".source = yamlFormat.generate "clangd-config" {
      CompileFlags = {
        Add = [
          "-xc++"
          "-Wall"
        ];
        Remove = [ ];
        Compiler = "clang++";
      };

      Diagnostics = {
        ClangTidy = {
          Add = [
            "bugprone-*"
            "performance-*"
            "portability-*"
            "readability-*"
            "google-*"
            "misc-*"
            "modernize-*"
          ];
          Remove = "modernize-use-trailing-return-type";
          CheckOptions = {
            "readability-identifier-naming.VariableCase" = "CamelCase";
          };
        };
        UnusedIncludes = "Strict";
      };

      Completion.AllScopes = true;
      Hover.ShowAKA = true;

      InlayHints = {
        Designators = true;
        Enabled = true;
        ParameterNames = true;
        DeducedTypes = true;
      };

      Index.StandardLibrary = "Yes";
    };
  };
}
