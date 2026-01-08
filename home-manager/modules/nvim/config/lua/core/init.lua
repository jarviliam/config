require("core.global")
require("core.options")
require("keymaps")
require("core.events")
require("commands")
require("core.lazyplug").setup()

local conf = require("conf")
vim.cmd(string.format("colorscheme %s", conf.theme))

if conf.theme == "gruvbox-material" then
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#32302f" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#32302f" })
  vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#32302f" })
  vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#32302f" })
end
