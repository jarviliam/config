----------------------------------------------------
--        _                  _ ___
--       (_)___ _______   __(_) (_)___ _____ ___
--      / / __ `/ ___/ | / / / / / __ `/ __ `__ \  
--     / / /_/ / /   | |/ / / / / /_/ / / / / / /
--  __/ /\__,_/_/    |___/_/_/_/\__,_/_/ /_/ /_/
-- /___/
--
----------------------------------------------------

vim.g.work_dir = vim.env.HOME .. '/work'
vim.g.personal_dir = vim.env.HOME .. '/Coding'

vim.g.do_filetype_lua = 1

local conf = require("conf")
require("settings")
require("keymaps")
require("commands")
require("autocmds")
require("core.global")
require("lazyplug")
require("lsp")

vim.cmd(string.format("colorscheme %s", conf.theme))
