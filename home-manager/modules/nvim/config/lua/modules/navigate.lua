local navigate = require("Navigator")
navigate.setup()
local map = vim.keymap.set
local default_options = { noremap = true, silent = true }

map("n", "<C-h>", navigate.left, default_options)
map("n", "<C-k>", navigate.up, default_options)
map("n", "<C-l>", navigate.right, default_options)
map("n", "<C-j>", navigate.down, default_options)
