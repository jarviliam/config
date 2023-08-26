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
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "/Users/liam.jarvis/.pyenv/versions/3.10.1/bin/python"

local conf = require("conf")
require("core.global")
require("core.auto")
require("core.settings")
require("core.mappings")
require("core.diagnostics")
require("lazyplug")

vim.cmd(string.format("colorscheme %s", conf.theme))
