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
--
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  local function map(...)
    vim.api.nvim_buf_set_keymap(0, ...)
  end
  local opts = { noremap = true, silent = false }

  -- Open the link under the caret.
  map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    opts
  )

  -- Open notes linking to the current buffer.
  map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
  -- Alternative for backlinks using pure LSP and showing the source context.
  --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Open notes linked by the current buffer.
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

  -- Preview a linked note.
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- Open the code actions for a visual selection.
  map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end
