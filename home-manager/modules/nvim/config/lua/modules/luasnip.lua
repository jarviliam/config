local ok, luasnip = as.safe_require("luasnip")
if not ok then
  return
end

require("luasnip.loaders.from_vscode").load()

local t = require("luasnip.util.types")

luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [t.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } },
      },
    },
  },
})

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
vim.keymap.set("i", "<c-m>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
