Config.later(function()
  vim.pack.add({
    "https://github.com/rachartier/tiny-code-action.nvim",
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  })
  local ta = require("tiny-code-action")
  ta.setup({
    picker = { "buffer", opts = { hotkeys = true } },
  })
  require("tiny-inline-diagnostic").setup({})
  Config.code_action = ta.code_action
end)
