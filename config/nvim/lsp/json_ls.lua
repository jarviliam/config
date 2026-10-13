---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = {
        { fileMatch = { "*.hujson", "*.jsonc" }, schema = { allowTrailingCommas = true } },
      },
    },
  },
}
