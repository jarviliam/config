return {
  "stevearc/resession.nvim",
  keys = {
    { "<leader>Sl", ":lua require('resession').load('Last Session')<CR>", desc = "Load last session" },
    { "<leader>Ss", ":lua require('resession').save()<CR>", desc = "Save this session" },
    {
      "<leader>SS",
      ":lua require('resession').save(vim.fn.getcwd(), { dir = 'dirsession'})<CR>",
      desc = "Save this dirsession",
    },
    { "<leader>Sd", ":lua require('resession').delete()<CR>", desc = "Delete a session" },
    { "<leader>SD", ":lua require('resession').delete(nil, {dir = 'dirsession'})<CR>", desc = "Delete a dirsession" },
    { "<leader>Sf", ":lua require('resession').load()<CR>", desc = "Load a session" },
    { "<leader>SF", ":lua require('resession').load(nil,{dir = 'dirsession')<CR>", desc = "Load a dirsession" },
    {
      "<leader>S.",
      ":lua require('resession').load(vim.fn.getcwd(),{dir = 'dirsession'})<CR>",
      desc = "Load cur dirsession",
    },
  },
  opts = {},
}
