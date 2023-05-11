local options = vim.opt

--- Mouse
options.mouse = ""

options.exrc = true
options.secure = true
options.modelines = 1 -- read a modeline at EOF
options.termguicolors = true
vim.g.guifont = "Hack Nerd Font Code Mono"
--options.guifont = "Fira Code Regular Nerd Font Complete Mono:h9"

--- Message outputs
options.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}

--- Timings
options.updatetime = 300
options.timeout = true
options.timeoutlen = 500
options.ttimeoutlen = 10

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
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}

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
options.cmdheight = 1 -- cmdline height
options.laststatus = 2 -- 2 = always show status line (filename, etc)
options.linespace = 0 -- font spacing
options.ruler = false
options.number = true -- show absolute line no. at the cursor pos
options.relativenumber = true -- otherwise, show relative numbers in the ruler
options.cursorline = true -- Show a line where the current cursor is
options.signcolumn = "yes:1" -- Show sign column as first column
vim.g.colorcolumn = "+1"

-- Indentation
options.wrap = true
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
-- options.listchars = {
-- 	eol = nil,
-- 	tab = "│ ",
-- 	extends = "›", -- Alternatives: … »
-- 	precedes = "‹", -- Alternatives: … «
-- 	trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
-- }
-- options.showbreak = [[↪ ]]

--- Wild and file globbing
options.wildmode = "longest:full,full"
options.wildignorecase = true
options.pumheight = 15
options.wildoptions = "pum" -- Show completion items using the pop-up-menu (pum)
options.pumblend = 3
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
options.completeopt = { "menuone", "noselect" }
options.autowriteall = true

options.smartindent = true -- add <tab> depending on syntax (C/C++)
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
options.smartcase = true
options.wrapscan = true -- begin search from top of the file when nothng is found
options.showmatch = true -- highlight matching [{()}]
options.scrolloff = 3 -- min number of lines to keep between cursor and screen edge
options.sidescrolloff = 5 -- min number of cols to keep between cursor and screen edge

-- Backups
options.writebackup = false
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
