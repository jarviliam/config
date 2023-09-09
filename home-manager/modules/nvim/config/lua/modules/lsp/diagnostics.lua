local M = {}

function M.setup()
  -- Automatically update diagnostics
  -- vim.diagnostic.config({
  --   virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  --   signs = false,
  --   underline = true,
  --   update_in_insert = false,
  --   severity_sort = true,
  --   float = {
  --     focusable = true,
  --     source = "always",
  --   },
  -- })

  -- for type, icon in pairs(as.style.lsp.signs) do
  --   local hl = "DiagnosticSign" .. type
  --   local col = "Diagnostic" .. type
  --   vim.fn.sign_define(hl, { text = icon, texthl = col })
  -- end
  vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])
end

return M
