---@type LazySpec
return {
  "stevearc/quicker.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>q",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
  },
}
