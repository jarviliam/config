local options= vim.opt
--- Mouse
options.mouse = ""

options.exrc = true
options.secure = true
options.modelines = 1 -- read a modeline at EOF
options.termguicolors = true
vim.g.guifont = "Hack Nerd Font Code Mono"
--options.guifont = "Fira Code Regular Nerd Font Complete Mono:h9"

--- Timings
options.updatetime = 300
options.timeout = true
options.timeoutlen = 500
options.ttimeoutlen = 10

options.undofile = true
options.backup = false
options.writebackup = false
vim.cmd('filetype plugin indent on')
-- vim clipboard copies to system clipboard
-- unnamed     = use the " register (cmd-s paste in our term)
-- unnamedplus = use the + register (cmd-v paste in our term)
options.clipboard = { "unnamedplus" }

--- Utils
options.showmode = false
options.sessionoptions = {
  "globals",
  "buffers",
  "curdir",
  "help",
  "winpos",
}
options.viewoptions = { "cursor", "folds" }
options.virtualedit = "block"

options.grepprg = [[rg --glob "!.git" --hidden --no-heading --vimgrep --follow $*]]
options.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }

--- Formatoptions
options.formatoptions = {
  ["1"] = true,
  ["2"] = true, -- Use indent from 2nd line of a paragraph
  q = true,     -- continue comments with gq"
  c = true,     -- Auto-wrap comments using textwidth
  r = true,     -- Continue comments when pressing Enter
  n = true,     -- Recognize numbered lists
  t = false,    -- autowrap lines using text width value
  j = true,     -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
if vim.fn.has('nvim-0.9') == 1 then
  options.shortmess:append('WcC')     -- Reduce command line messages
  options.splitkeep = 'screen'        -- Reduce scroll during window split
else
  options.shortmess:append('Wc')      -- Reduce command line messages
end

--- Spelling
options.spellsuggest:prepend({ 12 })
options.spelloptions = "camel"
options.spellcapcheck = "" -- don't check for capital letters at start of sentence
options.fileformats = { "unix", "mac", "dos" }

--- Display
options.showcmd = false -- show current command under the cmd line
options.breakindentopt = "sbr"
options.linebreak = true
options.conceallevel = 2
options.synmaxcol = 1024
options.cmdheight = 1         -- cmdline height
options.laststatus = 2        -- 2 = always show status line (filename, etc)
options.linespace = 0         -- font spacing
options.ruler = false
options.number = true         -- show absolute line no. at the cursor pos
options.relativenumber = true -- otherwise, show relative numbers in the ruler
options.cursorline = true     -- Show a line where the current cursor is
options.signcolumn = "yes"    -- Show sign column as first column
vim.g.colorcolumn = "+1"

-- Indentation
options.wrap = false
options.wrapmargin = 2
options.breakindent = true
options.textwidth = 80
options.autoindent = true
options.shiftwidth = 2
options.shiftround = true
options.expandtab = true

-- List Chars
options.list = true
options.listchars = { eol = "↩", tab = "▸ ", trail = "·" }
options.fillchars = {
  diff = "🮮",
  fold = "┉",
  foldopen = "▾",
  foldsep = "┊",
  foldclose = "▸",
  vert = "┃",
}

--- Wild and file globbing
options.wildmode = "longest:full,full"
options.wildignorecase = true
options.pumheight = 10
options.winblend = 10
options.wildoptions = "pum" -- Show completion items using the pop-up-menu (pum)
options.pumblend = 10
options.wildignore = {
  "*.aux",
  "*.out",
  "*.toc",
  "*.o",
  "*.obj",
  "*.dll",
  "*.jar",
  "*.pyc",
  "*.rbc",
  "*.class",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.wav",
  "*.*~",
  "*~ ",
  "*.swp",
  ".lock",
  ".DS_Store",
  "tags.lock",
}

-- show menu even for one item do not auto select/insert
options.completeopt = 'menuone,noinsert,noselect'
options.autowriteall = true

options.smartindent = true  -- add <tab> depending on syntax (C/C++)
options.startofline = false -- keep cursor column on navigation

options.tabstop = 4
options.shiftwidth = 4
options.smarttab = true -- Use shiftwidths at left margin, tabstops everywhere else

--- Window splitting / Buffers
options.splitbelow = true
options.splitright = true
options.eadirection = "hor"
options.switchbuf = "useopen,uselast"
options.fillchars = {
  vert = "▕", -- alternatives │
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

--- Folds
options.foldenable = false -- enable folding
options.foldopen = options.foldopen + "search"
options.foldlevelstart = 3 -- open most folds by default
options.foldexpr = "nvim_treesitter#foldexpr()"
options.foldmethod = "expr"

--- Searching / Matching
options.ignorecase = true
options.incsearch = true
options.infercase = true
options.smartcase = true
options.wrapscan = true   -- begin search from top of the file when nothng is found
options.showmatch = true  -- highlight matching [{()}]
options.scrolloff = 3     -- min number of lines to keep between cursor and screen edge
options.sidescrolloff = 5 -- min number of cols to keep between cursor and screen edge

-- Backups
options.swapfile = false

vim.g.markdown_fenced_languages = {
  "vim",
  "lua",
  "cpp",
  "sql",
  "python",
  "bash=sh",
  "console=sh",
  "javascript",
  "typescript",
  "js=javascript",
  "ts=typescript",
  "yaml",
  "json",
}
vim.cmd([[menu File.Save :w<CR>]])
vim.cmd([[menu File.Stop :q<CR>]])
vim.cmd([[menu File.Save :W<CR> ]])
vim.cmd([[menu File.Stop :Q<CR> ]])
