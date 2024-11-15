-- Improved quickfix UI.
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  opts = {},
  keys = {
    {
      "<leader>xx",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>xl",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Toggle loclist list",
    },
    {
      "<leader>xd",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setqflist()
        end
      end,
      desc = "Toggle diagnostics",
    },
  },
}
