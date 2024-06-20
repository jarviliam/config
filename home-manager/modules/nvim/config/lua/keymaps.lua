local map = vim.keymap.set
-----------------------------------------------------------------------------//
-- Core
-----------------------------------------------------------------------------//
map("v", ">", ">gv", { desc = "indent and reselect" }) -- reselect after >>
map("v", "<", "<gv", { desc = "dedent and reselect" }) -- reselect after <<

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll downwards" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
map("n", "n", "nzzzv", { desc = "Next result" })
map("n", "N", "Nzzzv", { desc = "Previous result" })

map("n", "Q", "<Nop>")

map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
-----------------------------------------------------------------------------//
-- buffers {{{1
-----------------------------------------------------------------------------//
map("n", "<TAB>", ":bnext<CR>", { silent = true, desc = "buffer: cycle forward" })
map("n", "<S-TAB>", ":bprevious<CR>", { silent = true, desc = "buffer: cycle backward" })

map("n", "vv", "V")
map("n", "V", "v$")
map("v", "k", "gk", { silent = true })
map("v", "j", "gj", { silent = true })

local map_toggle = function(lhs, rhs, desc)
  map("n", [[\]] .. lhs, rhs, { desc = desc })
end
map_toggle("b", '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', "Toggle 'background'")
map_toggle("c", "<Cmd>setlocal cursorline!<CR>", "Toggle 'cursorline'")
map_toggle("C", "<Cmd>setlocal cursorcolumn!<CR>", "Toggle 'cursorcolumn'")
map_toggle("d", "<Cmd>lua MiniBasics.toggle_diagnostic()<CR>", "Toggle diagnostic")
map_toggle("h", "<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>", "Toggle search highlight")
map_toggle("i", "<Cmd>setlocal ignorecase!<CR>", "Toggle 'ignorecase'")
map_toggle("l", "<Cmd>setlocal list!<CR>", "Toggle 'list'")
map_toggle("n", "<Cmd>setlocal number!<CR>", "Toggle 'number'")
map_toggle("r", "<Cmd>setlocal relativenumber!<CR>", "Toggle 'relativenumber'")
map_toggle("s", "<Cmd>setlocal spell!<CR>", "Toggle 'spell'")
map_toggle("w", "<Cmd>setlocal wrap!<CR>", "Toggle 'wrap'")

map("n", "<C-S>", ":update<CR>", { silent = true })

local function foldexpr(value)
  return function()
    vim.opt_local.foldmethod = value
  end
end

local function opts(desc)
  return { silent = true, desc = desc }
end

vim.keymap.set("n", "<leader>zm", foldexpr("manual"), opts("Set local foldmethod to manual"))
vim.keymap.set("n", "<leader>ze", foldexpr("expr"), opts("Set local foldmethod to expr"))
vim.keymap.set("n", "<leader>zi", foldexpr("indent"), opts("Set local foldmethod to indent"))
vim.keymap.set("n", "<leader>zk", foldexpr("marker"), opts("Set local foldmethod to marker"))
vim.keymap.set("n", "<leader>zs", foldexpr("syntax"), opts("Set local foldmethod to syntax"))

-- Tab navigation.
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab page" })
vim.keymap.set("n", "<leader>tn", "<cmd>tab split<cr>", { desc = "New tab page" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tab pages" })
vim.keymap.set("n", "<leader>gg", function()
  require("float").float_term("lazygit", {
    size = { width = 0.85, height = 0.8 },
  })
end, {desc="Lazygit"})
