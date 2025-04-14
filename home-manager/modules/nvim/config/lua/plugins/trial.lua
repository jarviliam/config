return {
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "fredrikaverpil/godoc.nvim",
    dev = false,
    version = "*",
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" },
    opts = {},
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
        -- stylua: ignore
        { "<leader>xx", function() require("trouble").toggle({ mode = "diagnostics" }) end, desc = "Trouble" },
    },
    opts = {
      auto_preview = false,
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    -- stylua: ignore
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        { "<leader>ft", function () require("todo-comments.fzf").todo() end, desc = "TODOs" },
    },
    event = "VeryLazy",
    lazy = true,
  },
}
