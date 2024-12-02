local diagnostic_icons = require("icons").diagnostics
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
        { path = "luvit-meta/library", words = { "vim%.uv", "vim%.loop" } },
      },
    },
  },
  -- { "justinsgithub/wezterm-types", dev = true, lazy = true },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "creativenull/efmls-configs-nvim",
    enabled = false,
    dependencies = { "neovim/nvim-lspconfig" },
  },
  { "yioneko/nvim-vtsls" },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = "BufReadPre",
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    },
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
      local configure_server = require("lsp").configure_server
      for server, opts in pairs(require("plugins.lsp.servers")) do
        configure_server(server, opts)
      end
    end,
  },
  { "maxandron/goplements.nvim" },
  {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
      require("lint").linters_by_ft = {
        -- python = { "ruff" },
        lua = { "luacheck" },
        terraform = { "tflint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
