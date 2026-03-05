Config.new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

Config.original_symbolkind = vim.deepcopy(vim.lsp.protocol.SymbolKind)
Config._cachedSymbols = nil

Config.populate_symbol_map = function()
  if Config._cachedSymbols ~= nil then
    return
  end
  -- Compute symbol kind map from "resolved" string kind to its "original" (as in
  -- LSP protocol). Those can be different after `MiniIcons.tweak_lsp_kind()`.
  local res = {}
  local double_map = vim.lsp.protocol.SymbolKind
  for k, v in pairs(double_map) do
    if type(k) == "string" and type(v) == "number" then
      res[double_map[v]] = k
    end
  end
  Config._cachedSymbols = res
end
