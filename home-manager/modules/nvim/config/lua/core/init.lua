require("core.global")
require("core.options")
require("keymaps")
require("core.events")
require("commands")
require("completion")
require("core.lazyplug")
require("lsp")

-- vim.api.nvim_create_autocmd("FileType", {
--     callback = function()
--         pcall(vim.treesitter.start)
--     end
-- })
--
local conf = require("conf")
vim.cmd(string.format("colorscheme %s", conf.theme))
