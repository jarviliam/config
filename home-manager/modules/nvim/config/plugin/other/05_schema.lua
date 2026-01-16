Config.later(function()
  vim.pack.add({
    "https://github.com/b0o/SchemaStore.nvim",
    "https://github.com/cenk1cenk2/schema-companion.nvim",
  }, { load = true })

  require("schema-companion").setup({})
end)
