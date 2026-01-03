---@type vim.lsp.Config
return {
  cmd = { "typos-lsp" },
  init_options = {
    -- config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml",
    diagnosticSeverity = "Hint",
  },
}
