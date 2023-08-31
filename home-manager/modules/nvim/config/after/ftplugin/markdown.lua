
vim.opt_local.spell = true
vim.opt_local.softtabstop = 1 -- if I have two spaces in a sentence, delete only one.
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "12crqnot"
vim.opt_local.comments = "n:>"
vim.opt_local.wrap = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "min:50,shift:2"
vim.opt_local.commentstring = "<!--%s-->"
vim.opt_local.conceallevel = 2

-- Formating support {{{
-- stylua: ignore start
local formatlistpat = {'^\\s*'}                         --- Optional leading whitespace
table.insert(formatlistpat, '[')                        --- Start character class
table.insert(formatlistpat, '\\[({]\\?')                --- |  Optionally match opening punctuation
table.insert(formatlistpat, '\\(')                      --- |  Start group
table.insert(formatlistpat, '[0-9]\\+')                 --- |  |  Numbers
table.insert(formatlistpat, [[\\\|]])                   --- |  |  or
table.insert(formatlistpat, '[a-zA-Z]\\+')              --- |  |  Letters
table.insert(formatlistpat, '\\)')                      --- |  End group
table.insert(formatlistpat, '[\\]:.)}')                 --- |  Closing punctuation
table.insert(formatlistpat, ']')                        --- End character class
table.insert(formatlistpat, '\\s\\+')                   --- One or more spaces
table.insert(formatlistpat, [[\\\|]])                   --- or
table.insert(formatlistpat, '^\\s*[-+*]\\s\\+')         --- Bullet points
vim.opt_local.formatlistpat = table.concat(formatlistpat, '')
vim.opt_local.comments = 'b:*,b:-'
vim.opt_local.foldtext = 'v:lua.custom_foldtext()'
vim.opt_local.foldmethod = 'expr'
--}}}
-- stylua: ignore end
