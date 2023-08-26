local M = {}
local wk = require("which-key")

function M.setup(client, bufnr)
  local keymaps = {
    l = {
      name = "+lsp",
      d = { vim.lsp.buf.definition, "GoTo Definition" },
      f = { vim.lsp.buf.format, "Format" },
      i = { vim.lsp.implementation, "Implementation" },
      r = { vim.lsp.buf.references, "References" },
      R = { vim.lsp.buf.rename, "Rename" },
      I = { "<cmd>LspInfo<cr>", "LSP Info" },
      j = { vim.diagnostic.goto_next, "Next Diagnostic" },
      k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    },
  }
  local vKeymaps = {}

  local map = vim.keymap.set
  map("n", "<leader>nd", vim.lsp.buf.definition, { silent = true, buffer = bufnr, desc = "lsp: definition" })
  map("n", "<leader>ni", vim.lsp.buf.implementation, { silent = true, buffer = bufnr, desc = "lsp: implementation" })
  map("n", "<leader>nr", vim.lsp.buf.references, { silent = true, buffer = bufnr, desc = "lsp: references" })
  map("n", "<c-k>", vim.lsp.buf.signature_help, { silent = true, buffer = bufnr, desc = "lsp: signature help" })
  map("n", "<leader>na", vim.lsp.buf.code_action, { silent = true, buffer = bufnr, desc = "lsp: code action" })
  map("n", "<leader>rr", vim.lsp.buf.rename, { silent = true, buffer = bufnr, desc = "lsp: rename" })
  map("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr, desc = "lsp: hover" })
  if client.server_capabilities.documentFormatting then
    map("n", "<leader>nf", vim.lsp.buf.format, { silent = true, buffer = bufnr, desc = "lsp: format" })
    keymaps.l.f = { vim.lsp.buf.format, "Format" }
  elseif client.server_capabilities.documentRangeFormatting then
    map("v", "<leader>F", vim.lsp.buf.range_format, { silent = true, buffer = bufnr })
    vKeymaps.l.f = { vim.lsp.buf.range_formatting, "Format Range" }
  end
  wk.register(keymaps, { buffer = bufnr, prefix = "<leader>" })
  wk.register(vKeymaps, { buffer = bufnr, prefix = "<leader>", mode = "v" })
end

return M
