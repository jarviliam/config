---@type vim.lsp.Config
return {
  cmd = { "marksman" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
