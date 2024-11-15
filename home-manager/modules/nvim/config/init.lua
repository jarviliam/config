----------------------------------------------------
--        _                  _ ___
--       (_)___ _______   __(_) (_)___ _____ ___
--      / / __ `/ ___/ | / / / / / __ `/ __ `__ \
--     / / /_/ / /   | |/ / / / / /_/ / / / / / /
--  __/ /\__,_/_/    |___/_/_/_/\__,_/_/ /_/ /_/
-- /___/
--
----------------------------------------------------

vim.g.work_dir = vim.env.HOME .. "/work"
vim.g.personal_dir = vim.env.HOME .. "/Coding"
vim.g.do_filetype_lua = 1
vim.g.enable_session = 1
vim.g._native_compl = false

vim.cmd.packadd("cfilter")
require("core")
require("gh")
