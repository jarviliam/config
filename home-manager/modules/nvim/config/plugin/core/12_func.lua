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

Config.set_launch_args = function(lang, args)
  local dap = require("dap")
  if dap.configurations[lang] == nil then
    error(("Configuration for %s is not defined!"):format(lang))
  end

  if type(args) ~= "table" and args ~= nil then
    error(("Invalid arguments %s of type %s specified! Must be a table or nil"):format(args, type(args)))
  end

  for _, config in ipairs(dap.configurations[lang]) do
    if config.request == "launch" then
      config.args = args
    end
  end
end
