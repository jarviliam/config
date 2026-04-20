Config.later(function()
  vim.pack.add({ "https://github.com/zenbones-theme/zenbones.nvim" })
  -- local zenbones = require("zenbones")
  vim.g.bones_compat = 1 -- use built-in vim highlight API, not lush.nvim

  vim.cmd("colorscheme zenburned")
end)
