Config.later(function()
  -- TODO: add mappings for treesitter search
  vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" }, { load = true })
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)
