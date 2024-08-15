require("core.global")
require("core.options")
require("keymaps")
require("core.events")
require("commands")
require("completion")
require("core.lazyplug")
require("lsp")

local conf = require("conf")

vim.cmd(string.format("colorscheme %s", conf.theme))
