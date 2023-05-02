local function everforest()
  vim.g.everforest_background = "medium"
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_diagnostic_text_highlight = 1
  vim.cmd("let g:everforest_diagnostic_virtual_text = 'colored'")
  vim.cmd("colorscheme everforest")
end

everforest()
