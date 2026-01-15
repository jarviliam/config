Config.later(function()
  vim.uv.fs_unlink(vim.lsp.log.get_filename())
  vim.lsp.log.set_level(vim.lsp.log.levels.WARN)
  vim.lsp.log.set_format_func(vim.inspect)

  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities({
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    }),
    root_markers = { ".git" },
  } --[[@as vim.lsp.Config]])

  vim
    .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
    :map(function(config_path)
      return vim.fs.basename(config_path):match("^(.*)%.lua$")
    end)
    :each(function(server_name)
      vim.lsp.enable(server_name)
    end)

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
      local hl_group = vim.api.nvim_create_augroup("jarviliam/cursor_highlights", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
        group = hl_group,
        desc = "Highlight references under cursor",
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        group = hl_group,
        desc = "Clear highlight references",
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end,
    desc = "Colors",
  })
  Config.toggle_hints = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
end)
