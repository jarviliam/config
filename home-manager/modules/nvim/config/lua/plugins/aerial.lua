return {
  "stevearc/aerial.nvim",
  keys = {
    { "<leader>so", ":lua require('aerial').toggle()<cr>", desc = "Symbols Outline" },
  },
  opts = {
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = { min_width = 28 },
    show_guides = true,
    filter_kind = false,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
    keymaps = {
      ["[y"] = "actions.prev",
      ["]y"] = "actions.next",
      ["[Y"] = "actions.prev_up",
      ["]Y"] = "actions.next_up",
      ["{"] = false,
      ["}"] = false,
      ["[["] = false,
      ["]]"] = false,
    },
    on_attach = function(bufnr)
      vim.keymap.set("n", "]y", function()
        require("aerial").next(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "[y", function()
        require("aerial").prev(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "]Y", function()
        require("aerial").next_up(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "[Y", function()
        require("aerial").prev_up(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
    end,
  },
}
