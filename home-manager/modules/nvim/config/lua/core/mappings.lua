vim.g.mapleader = " "
local l = "<leader>"
local map = vim.keymap.set

-----------------------------------------------------------------------------//
-- Core
-----------------------------------------------------------------------------//
map("v", ">", ">gv", { desc = "indent and reselect" }) -- reselect after >>
map("v", "<", "<gv", { desc = "dedent and reselect" }) -- reselect after <<

map("n", "Q", "<Nop>")

map({ "n", "v", "i" }, "<C-F>", "<Esc>gUiw`]a")

map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
-----------------------------------------------------------------------------//
-- buffers {{{1
-----------------------------------------------------------------------------//
map("n", "<TAB>", ":bnext<CR>", { silent = true, desc = "buffer: cycle forward" })
map("n", "<S-TAB>", ":bprevious<CR>", { silent = true, desc = "buffer: cycle backward" })

map("n", "vv", "V")
map("n", "V", "v$")
map("n", "k", "gk")
map("n", "j", "gj")
map("v", "k", "gk")
map("v", "j", "gj")

--Undo Tree---
map("n", l .. "u", ":UndotreeToggle<CR>", { silent = true, desc = "undo: toggle" })

map("n", l .. "q", ":lua require('core.utils').clear_buffers()<CR>", { silent = true, desc = "buffer: clear" })

-- Substitute
map("n", "s", require("substitute").operator)
map("n", "S", require("substitute").eol)
map("n", "ss", require("substitute").line)
