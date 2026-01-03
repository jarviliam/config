--- Creates a namespace
---@param name string
_G.ns = function(name)
  return vim.api.nvim_create_namespace(name)
end

local gr = vim.api.nvim_create_augroup("config", {})
--- Create an autocmd
---@param event vim.api.keyset.events
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

_G.ui = {
  icons = require("icons"),
  border = {
    name = "single",
    chars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  },
}
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

function _G.reload(name, children)
  children = children or false
  package.loaded[name] = nil
  if children then
    for pkg_name, _ in pairs(package.loaded) do
      if vim.startswith(pkg_name, name) then
        package.loaded[pkg_name] = nil
      end
    end
  end
  return require(name)
end
