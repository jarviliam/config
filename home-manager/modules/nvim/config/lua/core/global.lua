local gr = vim.api.nvim_create_augroup("config", {})
--- Create an autocmd
---@param event vim.api.keyset.events | table
---@param pattern string|table
---@param callback fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
---@param desc string
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

--- Create User Command
---@param name string
---@param callback string | fun(args: vim.api.keyset.create_user_command.command_args)
---@param opts vim.api.keyset.user_command
_G.Config.new_cmd = function(name, callback, opts)
  vim.api.nvim_create_user_command(name, callback, opts)
end

--- Create a floating window via snacks
---@param options table
---@param lines string[]
vim.ui.float = function(options, lines)
  ---@param self snacks.win
  local on_buf = function(self)
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  end
  return Snacks.win.new(vim.tbl_deep_extend("force", {}, options or {}, { on_buf = on_buf }))
end
