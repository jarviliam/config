--- Creates a namespace
---@param name string
_G.ns = function(name)
  return vim.api.nvim_create_namespace(name)
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
