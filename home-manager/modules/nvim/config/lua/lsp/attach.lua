local fmt_group = vim.api.nvim_create_augroup("LspFormatting", {})
local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts,
    { silent = true, buffer = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes  = 100
  end
if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
  end
if client.supports_method("textDocument/signatureHelp") then
      require("lsp_signature").on_attach({
        handler_opts = { border = "rounded" },
        hint_prefix = "",
        fixpos = true,
        padding = " ",
      }, bufnr)
    end

  local wk = require("which-key")
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
  wk.register(keymaps, { buffer = bufnr, prefix = "<leader>" })
  map("n", "K", vim.lsp.buf.hover,
    { desc = "hover information [LSP]" })
  map("n", "<leader>nd", vim.lsp.buf.definition,
    { desc = "goto definition [LSP]" })
  map("n", "<leader>nD", vim.lsp.buf.declaration,
    { desc = "goto declaration [LSP]" })
  map("n", "<leader>nr", vim.lsp.buf.references,
    { desc = "goto reference [LSP]" })
  map("n", "<leader>ni", vim.lsp.buf.implementation,
    { desc = "goto implementation [LSP]" })
  map("n", "<leader>nt", vim.lsp.buf.type_definition,
    { desc = "goto type definition [LSP]" })
  map("n", "<leader>na", "<cmd>FzfLua lsp_code_actions",
    {
      desc = "lsp: code actions",
      winopts = {
        relative = "cursor",
        row      = 1.01,
        col      = 0,
        height   = 0.20,
        width    = 0.55,
      }
    })
  map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "lsp: rename" })
  map("n", "<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    { desc = "signature help [LSP]" })
  map("n", "<leader>lt", "<cmd>lua require'lsp.diag'.toggle()<CR>",
    { desc = "toggle virtual text [LSP]" })

  local winopts = "{ float =  { border = 'rounded' } }"
  map("n", "[d", ("<cmd>lua vim.diagnostic.goto_prev(%s)<CR>"):format(winopts),
    { desc = "previous diagnostic [LSP]" })
  map("n", "]d", ("<cmd>lua vim.diagnostic.goto_next(%s)<CR>"):format(winopts),
    { desc = "next diagnostic [LSP]" })
  map("n", "<leader>lc", "<cmd>lua vim.diagnostic.reset()<CR>",
    { desc = "clear diagnostics [LSP]" })
  map("n", "<leader>l?",
    [[<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>]],
    { desc = "show line diagnostic [LSP]" })
  map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist()<CR>",
    { desc = "send diagnostics to quickfix [LSP]" })
  map("n", "<leader>lQ", "<cmd>lua vim.diagnostic.setloclist()<CR>",
    { desc = "send diagnostics to loclist [LSP]" })


  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local nls = require("modules.lsp.null")
  local enable = false
  if nls.has_formatter(ft) then
    enable = client.name == "null-ls"
  else
    enable = not (client.name == "null-ls")
  end

  client.server_capabilities.documentFormatting = enable
  -- format on save
  if client.server_capabilities.documentFormatting then
    vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = fmt_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          timeout_ms = 2000,
          bufnr = bufnr,
        })
      end,
    })
  end
end

return { on_attach = on_attach }
