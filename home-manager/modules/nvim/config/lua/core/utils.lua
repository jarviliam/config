local M = {}

function M.clear_buffers()
  local deleted = 0
  local current = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= current and (vim.api.nvim_buf_get_option(b, "modifiable")) then
      vim.api.nvim_buf_delete(b, {})
      deleted = deleted + 1
    end
  end
  print("Buffers Cleared: " .. deleted)
end

function M.shell(cmd, side)
  side = side or "right"
  cmd = cmd and string.format('$SHELL -C "%s"', cmd) or "$SHELL"
  local cur_win = vim.api.nvim_get_current_win()
  if side == "below" then
    vim.cmd([[botright split new]])
    vim.api.nvim_win_set_height(0, 12)
  elseif side == "right" then
    vim.cmd([[botright vsplit new]])
  end
  local buf = vim.api.nvim_get_current_buf()
  local termbuf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(termbuf)
  vim.api.nvim_buf_delete(buf, { force = true })
  vim.cmd([[set winhighlight=Normal:TelescopeNormal]])
  vim.fn.termopen(cmd)
  vim.api.nvim_set_current_buf(cur_win)
  return termbuf
end

---Common format-on-save for lsp servers that implements formatting
---@param client table
---@param buf integer
function M.fmt_on_save(client, buf)
  vim.api.nvim_err_writeln("Not")
end

return M
