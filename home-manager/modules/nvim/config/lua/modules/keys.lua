local wk = require("which-key")

wk.setup({
  show_help = false,
  triggers = "auto",
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC" },
  triggers_blacklist = {
    i = { "j", "k", "n" },
    v = { "j", "k" },
  },
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
  c = { o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" } },
  g = {
    name = "+git",
    g = { "<cmd>Neogit<CR>", "NeoGit" },
    c = { "<Cmd>FzfLua git_commits<CR>", "commits" },
    b = { "<Cmd>FzfLua git_branches<CR>", "branches" },
    s = { "<Cmd>FzfLua git_status<CR>", "status" },
    d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    h = { name = "+hunk" },
  },
  ["h"] = {
    name = "+help",
    t = { "<cmd>FzfLua builtin<cr>", "FzfLua" },
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
    a = { "<cmd>FzfLua autocommands<cr>", "Auto Commands" },
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
    b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
    s = {
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
          },
        })
      end,
      "Goto Symbol",
    },
    h = { "<cmd>Telescope command_history<cr>", "Command History" },
    m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
  },
  f = {
    name = "+fuzzy",
    f = { "<cmd>FzfLua files<cr>", "Find File" },
    g = { "<cmd>FzfLua git_files<cr>", "Find Files (Git)" },
    b = { "<cmd>FzfLua buffers<cr>", "Buffers" },
    n = { "<cmd>enew<cr>", "New File" },
  },
  x = {
    name = "+errors",
    x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble" },
    t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
    T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
    l = { "<cmd>lopen<cr>", "Open Location List" },
    q = { "<cmd>copen<cr>", "Open Quickfix List" },
  },
}
wk.register(leader, { prefix = "<leader>" })
