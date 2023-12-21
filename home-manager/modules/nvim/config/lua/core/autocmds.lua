local augroup = vim.api.nvim_create_augroup("JAutoCmd", {})
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = augroup, pattern = pattern, callback = callback, desc = desc })
end

au("TextYankPost", "*", function()
  vim.highlight.on_yank()
end, "Highlight yanked text")

local cursorLineGroup = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
vim.api.nvim_create_autocmd("WinLeave", {
  group = cursorLineGroup,
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
vim.api.nvim_create_autocmd("WinEnter", {
  group = cursorLineGroup,
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
---Clears cmdline after a few seconds
---@return function
local function clear_cmd()
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if vim.fn.mode() == "n" then
        vim.cmd([[echon '']])
      end
    end, 10000)
  end
end

local clearCommands = vim.api.nvim_create_augroup("ClearCommandMessages", { clear = true })
vim.api.nvim_create_autocmd({ "CmdlineLeave", "CmdlineChanged" }, {
  group = clearCommands,
  pattern = ":",
  callback = clear_cmd(),
})

local quick_close_filetypes = {
  "help",
  "qf",
  "netrw",
  "LuaTree",
  "tsplayground",
  "git-status",
  "dap-float",
  "codelldb",
  "repl",
}
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("QuickClose", { clear = true }),
  callback = function()
    local is_readonly = (vim.bo.readonly or not vim.bo.modifiable) and vim.fn.hasmapto("q", "n") == 0

    local is_eligible = vim.bo.buftype ~= ""
      or is_readonly
      or vim.wo.previewwindow
      or vim.tbl_contains(quick_close_filetypes, vim.bo.filetype)

    if is_eligible then
      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = 0, silent = true })
    end
  end,
})
--
-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "*.txt", "*.md", "*.tex", "gitcommit" }, command = "setlocal spell" }
)
local utilityGroup = vim.api.nvim_create_augroup("Utilities", { clear = true })
-- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = utilityGroup,
  pattern = "file:///*",
  callback = function()
    vim.cmd(string.format("bd!|edit %s", vim.uri_from_fname("<afile>")))
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_user_command("Todos", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Grep TODOs", nargs = 0 })
