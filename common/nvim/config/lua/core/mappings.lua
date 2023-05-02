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

-----------------------------------------------------------------------------//
-- buffers {{{1
-----------------------------------------------------------------------------//
map(
  "n",
  "<TAB>",
  ":bnext<CR>",
  { silent = true, desc = "buffer: cycle forward" }
)
map(
  "n",
  "<S-TAB>",
  ":bprevious<CR>",
  { silent = true, desc = "buffer: cycle backward" }
)

--Undo Tree---
map(
  "n",
  l .. "u",
  ":UndotreeToggle<CR>",
  { silent = true, desc = "undo: toggle" }
)

map(
  "n",
  l .. "q",
  ":lua require('core.utils').clear_buffers()<CR>",
  { silent = true, desc = "buffer: clear" }
)
