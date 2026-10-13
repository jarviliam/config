Config.later(function()
  vim.pack.add({ "https://github.com/danymat/neogen" }, { load = true })

  require("neogen").setup({
    enabled = true,
    input_after_comment = true,
    snippet_engine = "nvim",
  })
end)
