if vim.g._useTsgo == 1 then
  ---@type vim.lsp.Config
  return {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  }
end
