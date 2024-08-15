_G.__as_global_callbacks = __as_global_callbacks or {}
_G.as = {
  _store = __as_global_callbacks,
}

---Dumps text
---@param ... any
---@return any
function _G.dump_text(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, "\n"), "\n")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end
