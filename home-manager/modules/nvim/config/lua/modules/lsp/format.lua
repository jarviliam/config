--to delete
local M = {}

M.autoformat = true

local fmt_group = vim.api.nvim_create_augroup("LspFormatting", {})

function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    vim.notify("Enabled format on save")
  else
    vim.notify("Disabled format on save")
  end
end

function M.format()
  if M.autoformat then
    vim.lsp.buf.format()
  end
end

function M.setup(client, buf)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
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
    vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = buf })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = fmt_group,
      buffer = buf,
      callback = function()
        vim.lsp.buf.format({
          timeout_ms = 2000,
          bufnr = buf,
        })
      end,
    })
  end
end

return M
