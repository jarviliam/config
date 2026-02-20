Config.now(function()
  require("mini.icons").setup({})

  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind()
  Config.populate_symbol_map()
end)
