return {
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<cr>", "Join/split code block" },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "stevearc/resession.nvim",
    keys = {
      { "<leader>Sl", ":lua require('resession').load('Last Session')<CR>", "Load last session" },
      { "<leader>Ss", ":lua require('resession').save()<CR>", "Save this session" },
      {
        "<leader>SS",
        ":lua require('resession').save(vim.fn.getcwd(), { dir = 'dirsession'})<CR>",
        "Save this dirsession",
      },
      { "<leader>Sd", ":lua require('resession').delete()<CR>", "Delete a session" },
      { "<leader>SD", ":lua require('resession').delete(nil, {dir = 'dirsession'})<CR>", "Delete a dirsession" },
      { "<leader>Sf", ":lua require('resession').load()<CR>", "Load a session" },
      { "<leader>SF", ":lua require('resession').load(nil,{dir = 'dirsession')<CR>", "Load a dirsession" },
      {
        "<leader>S.",
        ":lua require('resession').load(vim.fn.getcwd(),{dir = 'dirsession'})<CR>",
        "Load cur dirsession",
      },
    },
    opts = {},
  },
}
