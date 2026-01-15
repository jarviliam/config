Config.later(function()
  vim.pack.add({ "https://github.com/neanias/everforest-nvim" }, { load = true })
  local everforest = require("everforest")
  everforest.setup({
    background = "soft",
  })
  everforest.load()
  vim.cmd("colorscheme everforest")
end)
