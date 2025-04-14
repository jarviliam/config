return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks", "snacks" } },
        { path = "blink.nvim", words = { "blink" } },
        { path = "lazy.nvim", words = { "LazyConfig", "LazySpec", "package" } },
      },
    },
    dependencies = {
      { "LuaCATS/luassert", name = "luassert-types" },
      { "LuaCATS/busted", name = "busted-types" },
      { "Bilal2453/luvit-meta" },
    },
  },
  { "yioneko/nvim-vtsls" },
  { "b0o/SchemaStore.nvim", version = false },
  { "maxandron/goplements.nvim" },
  {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
      vim.g.lint_enabled = true
      Snacks.toggle({
        name = "Lint",
        get = function()
          return vim.g.lint_enabled
        end,
        set = function(value)
          vim.g.lint_enabled = value
        end,
      }):map("\\u")
      local lua = require("lint").linters.luacheck
      lua.args = { "--globals", "vim", "Snacks", "--formatter", "plain", "--codes", "--ranges", "-" }
      require("lint").linters_by_ft = {
        -- python = { "ruff" },
        lua = { "luacheck" },
        terraform = { "tflint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        gitcommit = { "commitlint" },
        github = { "actionlint" },
        yaml = { "yamllint" },
        markdown = { "markdownlint-cli2" },
        -- text = { "write_good" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          if not vim.g.lint_enabled then
            return
          end
          require("lint").try_lint()
        end,
      })
    end,
  },
}
