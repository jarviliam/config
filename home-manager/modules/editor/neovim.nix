{
  config,
  flakePath,
  pkgs,
  ...
}:
{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home-manager/modules/nvim/config";
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
}
