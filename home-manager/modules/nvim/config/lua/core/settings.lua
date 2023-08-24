local o          = vim.opt
o.backup         = false
o.writebackup    = false
o.breakindent    = true -- Indent wrapped lines to match start
o.clipboard      = 'unnamedplus'
o.expandtab      = true
o.fillchars      = { eob = ' ', diff = ' ' }
o.hidden         = true
o.ignorecase     = true
o.inccommand     = 'split'
o.number         = true
o.pumblend       = 10
o.pumheight      = 10
o.relativenumber = true
o.scrolloff      = 6
o.shiftwidth     = 4
o.sidescroll     = 6
o.sidescrolloff  = 6
o.signcolumn     = 'yes:3'
o.grepprg        = "rg --vimgrep --no-heading --hidden --glob '!*{.git,node_modules,build,tags}'"
o.smartcase      = true
o.softtabstop    = 4
o.startofline    = false
o.swapfile       = false
o.tabstop        = 4
o.termguicolors  = true
o.textwidth      = 80
o.virtualedit    = 'block' -- allow cursor to exist where there is no character
o.winblend       = 10
o.wrap           = false

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- Avoid showing message extra message when using completion
o.shortmess:append('c')
o.completeopt:append {
    'noinsert',
    'menuone',
    'noselect',
    'preview'
}
o.shortmess:append('WcC') -- Reduce command line messages
o.splitkeep = 'screen'    -- Reduce scroll during window split

o.showbreak = '↳ '
o.mouse     = 'a'

o.diffopt:append {
    'linematch:50',
    'vertical',
    'foldcolumn:0',
    'indent-heuristic',
}

o.undolevels = 10000
o.undofile   = true
o.splitright = true
o.splitbelow = true
o.spell      = true

o.formatoptions:append {
    r = true, -- Automatically insert comment leader after <Enter> in Insert mode.
    o = true, -- Automatically insert comment leader after 'o' or 'O' in Normal mode.
    l = true, -- Long lines are not broken in insert mode.
    t = true, -- Do not auto wrap text
    n = true, -- Recognise lists
}

o.foldcolumn  = '0'
o.foldnestmax = 3
o.foldopen:append('jump')
o.list = true
o.listchars = { eol = "↩", tab = "▸ ", trail = "·" }

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
