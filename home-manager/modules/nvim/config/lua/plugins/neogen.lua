return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  cmd = { "Neogen" },
  keys = {
        {"<leader>og","<cmd>Neogen<cr>",desc="Generate definition"},
        {"<leader>of","<cmd>Neogen func<cr>",desc="Generate definition (F)"},
        {"<leader>oc","<cmd>Neogen class<cr>",desc="Generate definition (C)"},
    },
  opts = {
        enabled = true,
        input_after_comment = true,
        snippet_engine = "nvim"
    },
  version = "*",
}
