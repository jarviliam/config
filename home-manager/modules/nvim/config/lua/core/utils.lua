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

--- Lifted from @arsham . Thank you.
---Executes a command in normal mode.
---@param mode string @see vim.api.nvim_feedkeys().
---@param motion string what you mean to do in normal mode.
---@param special boolean? if provided and true replaces keycodes (<CR> to \r)
function M.normal(mode, motion, special) --{{{
  local sequence = vim.api.nvim_replace_termcodes(motion, true, false, special or false)
  vim.api.nvim_feedkeys(sequence, mode, true)
end --}}}

function M.call_and_center(fn)
  M.normal("n", "m'")
  fn()
  vim.schedule(function()
    M.normal("n", "zz")
  end)
end

---Creates a command from provided specifics on current buffer.
---@param name string
---@param command string|function
---@param opts? table
function M.buffer_command(name, command, opts) --{{{
  opts = opts or {}
  opts.force = true
  vim.api.nvim_buf_create_user_command(0, name, command, opts)
end --}}}
--
---Returns true if the buffer has the name variable. If it does not, it sets
-- the variable and returns false.
-- @param name The name of the variable to check.
-- @return boolean
function M.buffer_has_var(name) --{{{
  local ok, _ = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok then
    return true
  end
  vim.api.nvim_buf_set_var(0, name, true)
  return false
end --}}}

return M
