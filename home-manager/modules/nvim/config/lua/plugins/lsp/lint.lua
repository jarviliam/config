local languages = require("efmls-configs.defaults").languages()

-- NOTE: golang-ci-lint doesn't play well with efm
languages = vim.tbl_extend("force", languages, {
  lua = { require("efmls-configs.linters.luacheck") },
  yaml = {
    vim.tbl_extend("force", require("efmls-configs.linters.actionlint"), { parentMarkers = { ".github" } }),
    -- require("efmls-configs.linters.yamllint"),
  },
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
