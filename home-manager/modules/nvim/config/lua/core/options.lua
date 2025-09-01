local o = vim.opt

vim.g.ts_path = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "ts-install")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.cmdheight = 1
vim.opt.mouse = nil

vim.o.backup = false
vim.o.writebackup = false -- Don't store backup
vim.o.undofile = true -- Enable persistent undo

vim.opt.wildmode = "longest:full,full"
vim.opt.wildignorecase = true

vim.opt.grepprg = "rg --engine auto --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.clipboard = "unnamedplus"

vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- UI =========================================================================
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.colorcolumn = "+1" -- Draw colored column one step to the right of desired maximum width
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.laststatus = 2 -- Always show statusline
vim.o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list = true -- Show helpful character indicators
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true
vim.o.pumblend = 10 -- Make builtin completion menus slightly transparent
vim.o.pumheight = 10 -- Make popup menu smaller
vim.o.ruler = false -- Don't show cursor position
vim.o.shortmess = "aoOWFcSC" -- Disable certain messages from |ins-completion-menu|
vim.o.showmode = false -- Don't show mode in command line
vim.o.showtabline = 1
vim.o.signcolumn = "yes" -- Always show signcolumn or it would frequently shift
vim.o.splitkeep = "screen"
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.termguicolors = true -- Enable gui colors
vim.o.winblend = 10 -- Make floating windows slightly transparent
vim.o.wrap = false -- Display long lines as just one line

-- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch = true -- Show search results while typing
vim.o.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth = 2 -- Use this number of spaces for indentation
vim.o.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.tabstop = 2 -- Insert 2 spaces for a tab
vim.o.virtualedit = "block" -- Allow going past the end of line in visual block mode

vim.opt.complete:append("kspell") -- Add spellcheck options for autocomplete
vim.opt.complete:remove("t") -- Don't use tags for completion

o.spelllang = "en"
o.spell = false
vim.opt.dictionary = {
  "~/.local/share/dict/words-insane",
}

o.foldcolumn = "1"
o.foldlevelstart = 99
vim.wo.foldtext = ""

-- Disable Builtins
local builtins = {
  "gzip",
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "logiPat",
  "matchit",
  "matchparen",
  "netrw",
  "netrwFileHandlers",
  "netrwPlugin",
  "netrwSettings",
  "rrhelper",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in ipairs(builtins) do
  vim.g["loaded_" .. plugin] = 1
end
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Work around: https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight
