return {
  {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
      vim.g.lint_enabled = true
      local lint = require("lint")

      lint.linters.luacheck.args = { "--globals", "vim", "--formatter", "plain", "--codes", "--ranges", "-" }
      lint.linters.yamllint.args = {
        "--config",
        "~/.config/yamllint.yml",
      }

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

      Snacks.toggle({
        name = "Lint",
        get = function()
          return vim.g.lint_enabled
        end,
        set = function(value)
          vim.g.lint_enabled = value
        end,
      }):map("\\u")

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
