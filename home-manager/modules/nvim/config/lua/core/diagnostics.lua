-- for type, icon in pairs(as.style.lsp.signs) do
--   local hl = "DiagnosticSign" .. type
--   local col = "Diagnostic" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = col })
-- end
--
-- vim.diagnostic.config({
--   virtual_text = { spacing = 4, prefix = "●" },
--   signs = true,
--   underline = true,
--   update_in_insert = false,
--   severity_sort = true,
--   float = {
--     focusable = false,
--     style = "minimal",
--     border = "rounded",
--     source = "always",
--     header = "",
--     prefix = "",
--   },
-- })
--
-- 	-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])
--
for _, level in ipairs({ "Error", "Warn", "Info", "Hint" }) do
  vim.fn.sign_define(
    "DiagnosticSign" .. level,
    { text = "", numhl = "Diagnostic" .. level, linehl = "DiagnosticLine" .. level }
  )
end

vim.diagnostic.config({
  virtual_text  = false,
  signs         = true,
  underline     = true,
  severity_sort = true,
})
