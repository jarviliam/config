----------------------------------------------------
--        _                  _ ___
--       (_)___ _______   __(_) (_)___ _____ ___
--      / / __ `/ ___/ | / / / / / __ `/ __ `__ \  Nvim 0.9 Config
--     / / /_/ / /   | |/ / / / / /_/ / / / / / /
--  __/ /\__,_/_/    |___/_/_/_/\__,_/_/ /_/ /_/
-- /___/
--
----------------------------------------------------

vim.g.do_filetype_lua = 1

local conf = require("conf")
require("core.global")
require("core.auto")
require("core.settings")
require("core.mappings")
require("lazyplug")

vim.cmd(string.format("colorscheme %s", conf.theme))
