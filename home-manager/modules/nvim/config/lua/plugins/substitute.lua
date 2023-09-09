return {
  "gbprod/substitute.nvim",
  keys = {
    { "n", "sx", require("substitute.exchange").operator, { noremap = true } },
    { "n", "sxx", require("substitute.exchange").line, { noremap = true } },
    { "x", "X", require("substitute.exchange").visual, { noremap = true } },
    { "n", "sxc", require("substitute.exchange").cancel, { noremap = true } },
  },
  opts = {
    on_substitute = function(_)
      vim.cmd("normal ==")
    end,
  },
}
