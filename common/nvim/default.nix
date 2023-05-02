{ config, pkgs, lib, ... }:
with lib;
let
  python-debug = pkgs.python3.withPackages (p: with p; [ debugpy ]);
in
{
  config = mkIf config.my-home.useNeovim {
    programs.neovim = {
      package = pkgs.neovim-nightly;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-surround
        nvim-web-devicons
        navigator-nvim
        lualine-nvim
        fidget-nvim
        vim-eunuch
        undotree
        vim-startify
        neoscroll-nvim
        # Git info
        gitsigns-nvim
        diffview-nvim
        neogit
        octo-nvim
        # Indent lines
        indent-blankline-nvim
        # Auto close
        nvim-autopairs
        # Fast navigation
        lightspeed-nvim
        # Notify window
        nvim-notify
        # Commenting
        comment-nvim
        neogen

        telescope-nvim
        telescope-fzf-native-nvim
        trouble-nvim
        which-key-nvim
        fterm-nvim
        # Syntax highlighting
        nvim-treesitter.withAllGrammars

        # LSP
        nvim-lspconfig
        nvim-lsp-ts-utils
        null-ls-nvim
        nvim-navic

        # Completions
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-nvim-lsp-signature-help
        nvim-cmp
        lspkind-nvim

        # Snippets
        luasnip
        cmp_luasnip
        frendly-snippets

        # Debug adapter protocol
        nvim-dap
        telescope-dap-nvim
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-python

        nord-nvim
        sonokai
        edge
        everforest
        nightfox-nvim
        catppuccin-nvim
      ];

      extraPackages = with pkgs; [
        tree-sitter
        nodejs
        go
        gopls
        # Language Servers
        # Bash
        nodePackages.bash-language-server
        # Haskell
        stable.haskellPackages.haskell-language-server
        # Lua
        lua-language-server
        # Nix
        rnix-lsp
        nixpkgs-fmt
        statix
        # Python
        pyright
        python-debug
        black
        # Typescript
        nodePackages.typescript-language-server
        # Web (ESLint, HTML, CSS, JSON)
        nodePackages.vscode-langservers-extracted
        # Telescope tools
        ripgrep
        fd
      ];

      extraConfig = ''
        let g:python_debug_home = "${python-debug}"
        :luafile ~/.config/nvim/lua/init.lua
      '';
    };

    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
  };
}
