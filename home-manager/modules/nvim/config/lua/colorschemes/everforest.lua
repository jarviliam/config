return {
  "neanias/everforest-nvim",
  config = function()
    local everforest = require("everforest")
    everforest.setup({
      background = "soft",
    })
    everforest.load()
  end,
  lazy = false,
  priority = 1000,
}
