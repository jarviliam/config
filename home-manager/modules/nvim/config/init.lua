----------------------------------------------------
--        _                  _ ___
--       (_)___ _______   __(_) (_)___ _____ ___
--      / / __ `/ ___/ | / / / / / __ `/ __ `__ \
--     / / /_/ / /   | |/ / / / / /_/ / / / / / /
--  __/ /\__,_/_/    |___/_/_/_/\__,_/_/ /_/ /_/
-- /___/
--
----------------------------------------------------
vim.g._useTsgo = 0

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
require("mini.deps").setup()

_G.Config = {}

-- Define lazy helpers
Config.now = MiniDeps.now
Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
Config.later = MiniDeps.later
