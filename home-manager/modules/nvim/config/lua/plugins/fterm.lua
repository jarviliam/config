local floating_term_cmd = function()
  vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
  require("FTerm").toggle()
end

return {
  {
    "numToStr/FTerm.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local fterm = require("FTerm")
      fterm.setup(opts)
      vim.keymap.set({ "n", "i", "t", "v" }, "<C-/>", floating_term_cmd, { desc = "Toggle native terminal" })
    end,
  },
}
