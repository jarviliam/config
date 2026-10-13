Config.later(function()
  vim.pack.add({ "https://github.com/stevearc/quicker.nvim" }, {
    load = true,
  })
  require("quicker").setup({
    highlight = {
      treesitter = true,
    },
  })
end)
