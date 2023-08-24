return {
    "folke/which-key.nvim",
  event = "VeryLazy",
  init = function ()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
    config = function ()
   -- https://github.com/folke/which-key.nvim#colors
  vim.cmd([[highlight default link WhichKey          Label]])
  vim.cmd([[highlight default link WhichKeySeperator String]])
  vim.cmd([[highlight default link WhichKeyGroup     Include]])
  vim.cmd([[highlight default link WhichKeyDesc      Function]])
  vim.cmd([[highlight default link WhichKeyFloat     CursorLine]])
  vim.cmd([[highlight default link WhichKeyValue     Comment]])     
local wk = require("which-key")


wk.setup({
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC" },
  triggers_blacklist = {
    i = { "j", "k", "n" },
    v = { "j", "k" },
  },
  window = {
      border = "none",         -- none, single, double, shadow
      position = "bottom",     -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 1, 1, 1, 1 } -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 5                     -- spacing between columns
    },
    -- hide mapping boilerplate
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto" -- automatically setup triggers
})

local leader = {
  ["w"] = {
    name = "+windows",
    ["o"] = { "<C-W>p", "other-window" },
    ["w"] = { ":update<CR>", "update-window" },
    ["d"] = { "<C-W>c", "delete-window" },
    ["2"] = { "<C-W>v", "layout-double-columns" },
    ["h"] = { "<C-W>h", "window-left" },
    ["j"] = { "<C-W>j", "window-below" },
    ["l"] = { "<C-W>l", "window-right" },
    ["k"] = { "<C-W>k", "window-up" },
    ["H"] = { "<C-W>5<", "expand-window-left" },
    ["J"] = { ":resize +5", "expand-window-below" },
    ["L"] = { "<C-W>5>", "expand-window-right" },
    ["K"] = { ":resize -5", "expand-window-up" },
    ["="] = { "<C-W>=", "balance-window" },
    ["s"] = { "<C-W>s", "split-window-below" },
    ["v"] = { "<C-W>v", "split-window-right" },
  },
  g = {
    name = "+git",
    g = { "<cmd>Neogit<CR>", "NeoGit" },
    c = { "<Cmd>FzfLua git_commits<CR>", "commits" },
    C = { "<Cmd>FzfLua git_bcommits<CR>", "commits (buffer)" },
    b = { "<Cmd>FzfLua git_branches<CR>", "branches" },
    s = { "<Cmd>FzfLua git_status<CR>", "status" },
    d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    h = { name = "+hunk" },
  },
  ["h"] = {
    name = "+help",
    b = { "<cmd>FzfLua builtin<cr>", "FzfLua" },
    c = { "<cmd>FzfLua commands<cr>", "Commands" },
    h = { "<cmd>FzfLua help_tags<cr>", "Help Pages" },
    m = { "<cmd>FzfLua man_pages<cr>", "Man Pages" },
    k = { "<cmd>FzfLua keymaps<cr>", "Key Maps" },
    s = { "<cmd>FzfLua highlights<cr>", "Search Highlight Groups" },
    l = {
      [[<cmd>TSHighlightCapturesUnderCursor<cr>]],
      "Highlight Groups at cursor",
    },
    f = { "<cmd>FzfLua filetypes<cr>", "File Types" },
    o = { "<cmd>FzfLua vim_options<cr>", "Options" },
    a = { "<cmd>FzfLua autocmds<cr>", "Auto Commands" },
    p = {
      name = "+packer",
      p = { "<cmd>PackerSync<cr>", "Sync" },
      s = { "<cmd>PackerStatus<cr>", "Status" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      c = { "<cmd>PackerCompile<cr>", "Compile" },
    },
  },
  s = {
    name = "+search",
    b = { "<cmd>FzfLua grep_curbuf<cr>", "Buffer" },
    s = { "<cmd>FzfLua lsp_document_symbols<cr>", "Goto Symbol" },
    h = { "<cmd>FzfLua command_history<cr>", "Command History" },
    m = { "<cmd>FzfLua marks<cr>", "Jump to Mark" },
  },
  f = {
    name = "+fuzzy",
    f = { "<cmd>FzfLua files<cr>", "Find File" },
    [";"] = { "<cmd>FzfLua buffers<cr>", "buffers" },
    m = { "<cmd>FzfLua marks<cr>", "marks" },
    x = { "<cmd>FzfLua commands<cr>", "commands" },
    [":"] = { "<cmd>FzfLua command_history<cr>", "command history" },
    ["/"] = { "<cmd>FzfLua search_history<cr>", "search history" },
    ["?"] = { "<cmd>FzfLua builtin<cr>", "builtin" },
    M = { "<cmd>FzfLua man_pages<cr>", "man_pages" },
    w = { "<cmd>FzfLua grep_cword<cr>", "grep <word> (project)" },
    W = { "<cmd>FzfLua grep_cWORD<cr>", "grep <WORD> (project)" },
    z = { "<cmd>FzfLua spell_suggest<cr>", "spell" },
    g = { "<cmd>FzfLua git_files<cr>", "Find Files (Git)" },
    b = { "<cmd>FzfLua blines<cr>", "buffer lines" },
    B = { "<cmd>FzfLua lgrep_curbuf<cr>", "live grep (buffer)" },
    j = { "<cmd>FzfLua jumps<cr>", "jumps" },
    r = { "<cmd>FzfLua resume<cr>", "resume" },
    h = { "+help" }
  },
  x = {
    name = "+errors",
    x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble" },
    D = { "<cmd>FzfLua lsp_document_diagnostics<cr>", "Document diagnostics" },
    X = { "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "Workspace diagnostics" },
    l = { "<cmd>lopen<cr>", "Open Location List" },
    q = { "<cmd>copen<cr>", "Open Quickfix List" },
  },
  ["/"] = { "<cmd>FzfLua live_grep<cr>", "Live grep" }
}
wk.register(leader, { prefix = "<leader>" })
    end
  }
