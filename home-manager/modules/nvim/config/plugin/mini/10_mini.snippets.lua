Config.later(function()
  vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_lang(),
    },
  })

  MiniSnippets.start_lsp_server()
end)
