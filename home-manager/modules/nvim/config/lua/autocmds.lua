local function augroup(name)
  return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  desc = "Highlight on Yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", priority = 250 })
  end,
})

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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("QuickClose", { clear = true }),
  desc = "Close with q",
  pattern = {
    "help",
    "git",
    "qf",
    "man",
    "Scratch",
    "netrw",
    "tsplayground",
    "git-status",
    "dap-float",
    "codelldb",
    "repl",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

--
-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "*.txt", "*.md", "*.tex", "gitcommit" }, command = "setlocal spell" }
)
-- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = augroup("utilities"),
  pattern = "file:///*",
  callback = function()
    vim.cmd(string.format("bd!|edit %s", vim.uri_from_fname("<afile>")))
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("focusing"),
  command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
