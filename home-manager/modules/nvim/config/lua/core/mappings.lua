vim.g.mapleader = " "
local l = "<leader>"
local map = vim.keymap.set

-----------------------------------------------------------------------------//
-- Core
-----------------------------------------------------------------------------//
map("v", ">", ">gv", { desc = "indent and reselect" }) -- reselect after >>
map("v", "<", "<gv", { desc = "dedent and reselect" }) -- reselect after <<

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
map("v", "k", "gk")
map("v", "j", "gj")

--Undo Tree---
map("n", l .. "u", ":UndotreeToggle<CR>", { silent = true, desc = "undo: toggle" })

map("n", l .. "q", ":lua require('core.utils').clear_buffers()<CR>", { silent = true, desc = "buffer: clear" })

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

-- Substitute
--map("n", "s", require("substitute").operator)
--map("n", "S", require("substitute").eol)
--map("n", "ss", require("substitute").line)
--
local function foldexpr(value)
  return function()
    vim.opt_local.foldmethod = value
  end
end

local function opts(desc)
  return { silent = true, desc = desc }
end

vim.keymap.set("o", "H", "^", opts("To the beginning of line"))
vim.keymap.set("o", "L", "$", opts("To the end of line"))

vim.keymap.set("n", "<leader>zm", foldexpr("manual"), opts("Set local foldmethod to manual"))
vim.keymap.set("n", "<leader>ze", foldexpr("expr"), opts("Set local foldmethod to expr"))
vim.keymap.set("n", "<leader>zi", foldexpr("indent"), opts("Set local foldmethod to indent"))
vim.keymap.set("n", "<leader>zk", foldexpr("marker"), opts("Set local foldmethod to marker"))
vim.keymap.set("n", "<leader>zs", foldexpr("syntax"), opts("Set local foldmethod to syntax"))
