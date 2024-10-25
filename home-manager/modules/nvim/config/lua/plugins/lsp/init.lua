local diagnostic_icons = require("icons").diagnostics
local workspace_diagnostics_enabled = false
vim.g._workspace_diagnostics_enabled = workspace_diagnostics_enabled

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
  { "justinsgithub/wezterm-types", dev = true, lazy = true },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "creativenull/efmls-configs-nvim",
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
      {
        "artemave/workspace-diagnostics.nvim",
        enabled = workspace_diagnostics_enabled,
        dev = true,
      },
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
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        nix = { "nixfmt" },
        terraform = { "terraform_fmt" },
        html = { "prettierd" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
