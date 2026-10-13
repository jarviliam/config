Config.later(function()
  vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_lang(),
    },
  })

  MiniSnippets.start_lsp_server()

  local make_stop = function()
    local au_opts = { pattern = "*:n", once = true }
    au_opts.callback = function()
      while MiniSnippets.session.get() do
        MiniSnippets.session.stop()
      end
    end
    vim.api.nvim_create_autocmd("ModeChanged", au_opts)
  end
  local opts = { pattern = "MiniSnippetsSessionStart", callback = make_stop }
  _G.Config.new_autocmd("User", opts)
  local fin_stop = function(args)
    if args.data.tabstop_to == "0" then
      MiniSnippets.session.stop()
    end
  end
  local au_opts = { pattern = "MiniSnippetsSessionJump", callback = fin_stop }
  _G.Config.new_autocmd("User", au_opts)
end)
