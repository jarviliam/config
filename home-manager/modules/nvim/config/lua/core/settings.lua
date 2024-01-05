local o = vim.opt
local arrows = require("icons").arrows

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.skip_ts_context_commentstring_module = true
-- Visual {{{
o.termguicolors = true
o.pumheight = 15
o.cmdheight = 1
o.title = true
o.titlestring:append("%t")
o.number = true
o.relativenumber = true
o.lazyredraw = false
o.laststatus = 3
o.signcolumn = "auto:3"

o.scrolloff = 3
o.sidescroll = 1
o.sidescrolloff = 15
-- }}}

-- Indentation {{{
o.autoindent = true
o.softtabstop = 4
o.tabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.expandtab = true
-- }}}

o.mouse = nil

-- Navigation {{{
o.hidden = true
o.whichwrap:append("h,l")
-- }}}

-- Editing {{{
o.formatoptions:append("n")
-- o.formatoptions:append({
--   r = true, -- Automatically insert comment leader after <Enter> in Insert mode.
--   o = true, -- Automatically insert comment leader after 'o' or 'O' in Normal mode.
--   l = true, -- Long lines are not broken in insert mode.
--   t = true, -- Do not auto wrap text
--   n = true, -- Recognise lists
-- })
o.linebreak = true
-- }}}

-- Presentation {{{
o.textwidth = 79
o.colorcolumn = ""
o.wrap = false
o.conceallevel = 2
o.list = true
-- o.listchars = { eol = "↩", tab = "▸ ", trail = "·" }
o.listchars = {
  tab = "⇥ ",
  leadmultispace = "┊ ",
  multispace = "│ ",
  trail = "␣",
  nbsp = "⍽",
  extends = "◣",
  precedes = "◢",
}
o.synmaxcol = 256
o.history = 10000
-- }}}
--
local function update_lead()
  local lcs = vim.opt_local.listchars:get()
  local tab = vim.fn.str2list(lcs.tab)
  local space = vim.fn.str2list(lcs.multispace or lcs.space)
  local lead = { tab[1] }
  for i = 1, vim.bo.tabstop - 1 do
    lead[#lead + 1] = space[i % #space + 1]
  end
  vim.opt_local.listchars:append({ leadmultispace = vim.fn.list2str(lead) })
end
vim.api.nvim_create_autocmd("OptionSet", { pattern = { "listchars", "tabstop", "filetype" }, callback = update_lead })
vim.api.nvim_create_autocmd("VimEnter", { callback = update_lead, once = true })

-- Wildmenu {{{
-- enable ctrl-n and ctrl-p to scroll through matches
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignorecase = true

-- stuff to ignore when tab completing
vim.opt.wildignore = {
  "*~",
  "*.o",
  "*.obj",
  "*.so",
  "*vim/backups*",
  "*.git/**",
  "**/.git/**",
  "*sass-cache*",
  "*DS_Store*",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "*.pyc",
  "log/**",
  "*.png",
  "*.jpg",
  "*.gif",
  "*.zip",
  "*.bg2",
  "*.gz",
  "*.db",
  "**/node_modules/**",
  "**/bin/**",
  "**/thesaurus/**",
}
-- }}}

o.breakindent = true -- Indent wrapped lines to match start
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.inccommand = "nosplit"
o.showmatch = true

o.grepprg = "rg --vimgrep"
o.grepformat = "%f:%l:%c:%m"
o.virtualedit = "block" -- allow cursor to exist where there is no character
o.modeline = true

o.splitbelow = true
o.splitright = true
o.fillchars = {
  horizup = "┻",
  horiz = "━",
  horizdown = "┳",
  vert = "┃",
  vertright = "┣",
  vertleft = "┫",
  verthoriz = "╋",
  diff = "╱",
    foldclose = arrows.right,
    foldopen = arrows.down,
foldsep = ' ',
        fold = ' ',

}

vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- Avoid showing message extra message when using completion
o.completeopt:append({ "menuone", "noinsert", "noselect" })

-- Shortmess {{{
-- f -> Use "(3 of 5)" instead of "(file 3 of 5)"
-- i -> Use "[noeol]" instead of "[Incomplete last line]"
-- l -> Use "999L, 888C" instead of "999 lines, 888 characters"
-- m -> Use "[+]" instead of "[Modified]"
-- n -> Use "[New]" instead of "[New File]"
-- r -> Use "[RO]" instead of "[readonly]"
-- x -> Use "[dos]" instead of "[dos format]", "[unix]" instead of [unix format]" and "[mac]" instead of "[mac format]".
-- a -> All of the above abbreviations
-- o -> Overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
-- O -> Message for reading a file overwrites any previous message.  Also for quickfix message (e.g., ":cn").
-- t -> Truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column.  Ignored in Ex mode.
-- T -> Truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle.  Ignored in Ex mode.
-- A -> Don't give the "ATTENTION" message when an existing swap file is found.
-- I -> Don't give the intro message when starting Vim |:intro|.
-- c -> Avoid showing message extra message when using completion
o.shortmess:append("filmnrxoOtTAIcCs")
-- }}}

o.diffopt:append({
  "linematch:60",
  "algorithm:patience",
  "context:99",
  "indent-heuristic",
})

-- Undo / Backup {{{
o.undofile = true
o.undolevels = 10000
local undodir = "~/.cache/nvim/undodir"
local backdir = "~/.cache/nvim/backdir"

vim.opt.undodir = vim.fs.normalize(undodir)
vim.opt.backupdir = vim.fs.normalize(backdir)
vim.opt.directory = vim.fs.normalize(backdir)
-- }}}

-- Language {{{
o.spelllang = "en"
o.spell = false
vim.opt.dictionary = {
  "~/.local/share/dict/words-insane",
}
--}}}
--
o.updatetime = 50

o.foldcolumn = "1"
o.foldnestmax = 3
o.foldlevelstart = 99
-- NOTE: DISABLED DUE TO RELOAD BUG
-- o.foldmethod = "expr"
-- wo.foldtext = "v:lua.vim.treesitter.foldtext()"
-- wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

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
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
