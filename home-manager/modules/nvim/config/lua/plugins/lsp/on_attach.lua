return function (options)
  return function (client,bufnr)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover information [LSP]" })
	vim.keymap.set("n", "<leader>nd", vim.lsp.buf.definition, { desc = "goto definition [LSP]" })
	vim.keymap.set("n", "<leader>nD", vim.lsp.buf.declaration, { desc = "goto declaration [LSP]" })
	vim.keymap.set("n", "<leader>nr", vim.lsp.buf.references, { desc = "goto reference [LSP]" })
	vim.keymap.set("n", "<leader>ni", vim.lsp.buf.implementation, { desc = "goto implementation [LSP]" })
	vim.keymap.set("n", "<leader>nt", vim.lsp.buf.type_definition, { desc = "goto type definition [LSP]" })
  if client.supports_method("textDocument/codeAction") then
    vim.keymap.set("n", "<leader>na", "<cmd>FzfLua lsp_code_actions", {
      desc = "lsp: code actions",
      winopts = {
        relative = "cursor",
        row = 1.01,
        col = 0,
        height = 0.20,
        width = 0.55,
      },
    })
  end
  if client.supports_method("textDocument/rename") then
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "lsp: rename" })
  end

  if client.supports_method("textDocument/signatureHelp") then
      vim.keymap.set("n", "<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "signature help [LSP]" })
      require("lsp_signature").on_attach({
        handler_opts = { border = "rounded" },
        hint_prefix = "",
        fixpos = true,
        padding = " ",
      }, bufnr)
    end
  if
      client.supports_method("textDocument/publishDiagnostics")
      or client.supports_method("textDocument/diagnostic")
    then
    -- vim.cmd(
    --   [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]]
    -- )
      vim.api.nvim_create_autocmd("CursorHold",{
        callback = function ()
          vim.diagnostic.open_float({focusable=false})
        end,
        buffer = bufnr
      })
  end
  end
end
