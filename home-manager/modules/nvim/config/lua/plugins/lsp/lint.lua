local languages = require("efmls-configs.defaults").languages()

-- NOTE: golang-ci-lint doesn't play well with efm
languages = vim.tbl_extend("force", languages, {
  go = {
    require("efmls-configs.formatters.gofmt"),
    require("efmls-configs.formatters.goimports"),
  },
  python = { require("efmls-configs.formatters.ruff") },
  lua = { require("efmls-configs.formatters.stylua"), require("efmls-configs.linters.luacheck") },
  nix = { require("efmls-configs.formatters.nixfmt") },
  terraform = { require("efmls-configs.formatters.terraform_fmt") },
  yaml = {
    require("efmls-configs.formatters.prettier_d"),
    vim.tbl_extend("force", require("efmls-configs.linters.actionlint"), { parentMarkers = { ".github" } }),
    -- require("efmls-configs.linters.yamllint"),
  },
  html = { require("efmls-configs.formatters.prettier_d") },
})
for _, filetype in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
  languages[filetype] = {
    vim.tbl_extend("force", require("efmls-configs.linters.eslint"), {}),
  }
end

return {
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = true, documentRangeFormatting = true },
  settings = {
    logLevel = 1,
    version = 2,
    rootMarkers = { ".git/" },
    languages = languages,
  },
}
