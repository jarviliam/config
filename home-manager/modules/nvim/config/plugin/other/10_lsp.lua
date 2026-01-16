Config.later(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = true })

  vim.uv.fs_unlink(vim.lsp.log.get_filename())
  vim.lsp.log.set_level(vim.lsp.log.levels.WARN)
  vim.lsp.log.set_format_func(vim.inspect)

  local servers = {
    "gopls",
    "lua_ls",
    "basedpyright",
    "ruff",
    "marksman",
    "harper_ls",
    "jsonls",
    "yamlls",
    "bashls",
    "clangd",
    "github-actions-languageserver",
    "nixd",
    "tsgo",
    "typos-lsp",
    "zls",
    "terraformls",
  }

  vim.lsp.enable(servers)

  Config.new_cmd("LspLog", function()
    vim.cmd.tabnew(vim.lsp.log.get_filename())
  end, { desc = "Open LSP log" })

  Config.new_autocmd("LspAttach", {
    callback = function(ev)
      vim.lsp.document_color.enable(true, ev.buf)
      Snacks.toggle({
        name = "Color",
        get = function()
          return vim.lsp.document_color.is_enabled()
        end,
        set = function(state)
          vim.lsp.document_color.enable(not state)
        end,
      }):map("\\c")
    end,
    desc = "Colors",
  })
  Config.toggle_hints = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end)
