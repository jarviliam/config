Config.later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { load = true })

  local lint = require("lint")
  lint.linters.luacheck.args = { "--globals", "vim", "--formatter", "plain", "--codes", "--ranges", "-" }
  lint.linters.yamllint.args = {
    "--config",
    "~/.config/yamllint.yml",
  }

  lint.linters_by_ft = {
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

  Config.new_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
      lint.try_lint()
    end,
  })
end)
