local neogen = require("neogen")

local map = vim.keymap.set

neogen.setup({
  enabled = true,
  input_after_comment = true,
  snippet_engine = "luasnip",
})

map(
  "n",
  "<leader>og",
  neogen.generate,
  { silent = true, desc = "neogen: generate" }
)
map("n", "<leader>of", function()
  neogen.generate({ type = "func" })
end, { silent = true, desc = "neogen: generate function" })
map("n", "<leader>oc", function()
  neogen.generate({ type = "class" })
end, { silent = true, desc = "neogen: generate class" })
