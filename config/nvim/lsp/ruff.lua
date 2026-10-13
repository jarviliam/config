---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = {
    "pyproject",
    "python",
    "toml.pyproject",
  },
  root_markers = { "pyproject.toml", ".ruff.toml", "ruff.toml" },
}
