return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    local neogen = require("neogen")
    neogen.setup({
      enabled = true,
      input_after_comment = true,
      snippet_engine = "luasnip",
    })
    vim.keymap.set("n", "<leader>og", neogen.generate, { silent = true, desc = "neogen: generate" })
    vim.keymap.set("n", "<leader>of", function()
      neogen.generate({ type = "func" })
    end, { silent = true, desc = "neogen: generate function" })
    vim.keymap.set("n", "<leader>oc", function()
      neogen.generate({ type = "class" })
    end, { silent = true, desc = "neogen: generate class" })
  end,
  version = "*",
}

