local M = {}

--- [TODO:description]
---@param bufnr integer
---@return vim.lsp.Client | nil
M.get_client = function(bufnr)
  ---@type vim.lsp.Client[]
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
  })

  for _, c in ipairs(clients) do
    if c.name == "prlsp" then
      return c
    end
  end
  return nil
end

M.open = function()
  local sourceBufnr = vim.api.nvim_get_current_buf()
  local aer_bufnr = vim.api.nvim_create_buf(false, true)
  vim.cmd("noau vertical topleft 1split")
  local winid = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(winid, aer_bufnr)
  vim.api.nvim_win_set_width(winid, 40)

  local client = M.get_client(sourceBufnr)
  vim.print(client ~= nil and client.name or "nil")
  assert(client ~= nil)

  -- client:request("textDocument/")
end

Config.pr = M
