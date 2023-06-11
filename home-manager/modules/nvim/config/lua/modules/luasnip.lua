local ok, ls = pcall(require, "luasnip")
if not ok then return end
local map = vim.keymap.set


local t = require("luasnip.util.types")

ls.config.set_config({
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

require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend('javascript', { 'javascriptreact', 'typescriptreact' })
require 'snippets'

-- vim.keymap.set({ "i", "s" }, "<C-l>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
--
-- -- <c-j> is my jump backwards key.
-- -- this always moves to the previous item within the snippet
-- vim.keymap.set({ "i", "s" }, "<C-h>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })
--
-- -- <c-l> is selecting within a list of options.
-- vim.keymap.set("i", "<c-m>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end)

map({ 'i', 's' }, '<C-l>', function()
  if ls.expand_or_locally_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = 'jump forward or expand snippet' })
map({ 'i', 's' }, '<C-h>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = 'jump backward in snippet' })
-- FIX: Only local choice (on the current snippet) should be considered <13-03-22, kunzaatko> --
map({ 'i', 's' }, '<C-k>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = 'choose next ChoiceNode' })
map({ 'i', 's' }, '<C-j>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end, { silent = true, desc = 'choose prev ChoiceNode' })
