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
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous result" })

-- Powerful <esc>.
vim.keymap.set({ "i", "s", "n" }, "<esc>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").unlink_current()
  end
  vim.cmd("noh")
  return "<esc>"
end, { desc = "Escape, clear hlsearch, and stop snippet session", expr = true })

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

map("n", "ga", function()
  Snacks.terminal("gh dash")
end, { desc = "GH Dash" })
