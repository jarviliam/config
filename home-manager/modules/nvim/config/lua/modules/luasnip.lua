local ok, ls = pcall(require, "luasnip")
if not ok then return end
local map = vim.keymap.set


local t = require("luasnip.util.types")

local ft_functions = require 'luasnip.extras.filetype_functions'
ls.config.set_config({
  history = false,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ft_func = ft_functions.from_filetype,
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
