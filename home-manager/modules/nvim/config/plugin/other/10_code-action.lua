Config.later(function()
  vim.pack.add({ "https://github.com/rachartier/tiny-code-action.nvim" }, { load = true })
  local ta = require("tiny-code-action")
  ta.setup({
    picker = { "buffer", opts = { hotkeys = true } },
  })
  Config.code_action = ta.code_action
end)
