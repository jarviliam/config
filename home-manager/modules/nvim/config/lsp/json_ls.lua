---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc", "json5" },
  init_options = {
    provideFormatter = false,
  },
  settings = {
    schemas = require("schemastore").json.schemas(),
  },
}
