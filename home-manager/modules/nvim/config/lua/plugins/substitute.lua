return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "S",
      function()
        require("substitute").visual()
      end,
      mode = "x",
    },
    {
      "S",
      function()
        require("substitute").operator()
      end,
      mode = "n",
    },
    {
      "sx",
      function()
        require("substitute.exchange").operator()
      end,
      { mode = "n", noremap = true },
    },
    {
      "sxx",
      function()
        require("substitute.exchange").line()
      end,
      { mode = "n", noremap = true },
    },
    {
      "X",
      function()
        require("substitute.exchange").visual()
      end,
      mode = "x",
    },
    {
      "sxc",
      function()
        require("substitute.exchange").cancel()
      end,
      mode = { "n", "x" },
    },
    -- { "n", "sx", require("substitute.exchange").operator, { noremap = true } },
    -- { "n", "sxx", require("substitute.exchange").line, { noremap = true } },
    -- { "x", "X", require("substitute.exchange").visual, { noremap = true } },
    -- { "n", "sxc", require("substitute.exchange").cancel, { noremap = true } },
  },
  opts = {
    on_substitute = function(_)
      vim.cmd("normal ==")
    end,
  },
}
