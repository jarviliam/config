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
  opts = {
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local ignored_bufs = { "trouble" }
      if buftype ~= "" and buftype ~= "acwrite" then
        return false
      end
      if vim.tbl_contains(ignored_bufs, buftype) then
        return false
      end
      return vim.bo[bufnr].buflisted
    end,
  },
}
