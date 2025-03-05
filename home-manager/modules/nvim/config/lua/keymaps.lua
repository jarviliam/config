local map = vim.keymap.set

-- better indenting
map("v", "<", "<gv", { desc = "Indent Left" })
map("v", ">", ">gv", { desc = "Indent Right" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll downwards" })
map("n", "<C-f>", "<C-f>zz", { desc = "Scroll downwards, fullpage" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
map("n", "<C-b>", "<C-b>zz", { desc = "Scroll upwards, fullpage" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-----------------------------------------------------------------------------//
-- buffers {{{1
-----------------------------------------------------------------------------//
map("n", "<TAB>", ":bnext<CR>", { silent = true, desc = "buffer: cycle forward" })
map("n", "<S-TAB>", ":bprevious<CR>", { silent = true, desc = "buffer: cycle backward" })

map("n", "vv", "V")
map("n", "V", "v$")

local map_toggle = function(lhs, rhs, desc)
  map("n", [[\]] .. lhs, rhs, { desc = desc })
end
map_toggle("b", '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', "Toggle 'background'")
map_toggle("h", "<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>", "Toggle search highlight")

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Tab navigation.
vim.keymap.set("n", "<leader>Tc", "<cmd>tabclose<cr>", { desc = "Close tab page" })
vim.keymap.set("n", "<leader>Tn", "<cmd>tab split<cr>", { desc = "New tab page" })
vim.keymap.set("n", "<leader>To", "<cmd>tabonly<cr>", { desc = "Close other tab pages" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
