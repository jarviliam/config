local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

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

_G.Config.new_autocmd({ "CmdlineLeave", "CmdlineChanged" }, ":", clear_cmd, "Clear command line")
_G.Config.new_autocmd("FileType", {
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
}, function(e)
  vim.bo[e.buf].buflisted = false
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = e.buf, silent = true })
end, "Close with q.")

_G.Config.new_autocmd("FileType", { "man" }, function(e)
  vim.bo[e.buf].buflisted = false
end, "Easier inline man-files closing")

_G.Config.new_autocmd("FileType", { "json", "jsonc", "json5" }, function()
  vim.opt_local.conceallevel = 0
end, "Conceal Json files")

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "*.txt", "*.md", "*.tex", "gitcommit" }, command = "setlocal spell" }
)

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
  desc = "Start treesitter for filetype",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("buffer_reload"),
  desc = "Go to the last location when opening a buffer",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("treesitter_fold"),
  desc = "Enable Treesitter folding",
  callback = function(args)
    local bufnr = args.buf

    -- Enable Treesitter folding when not in huge files and when Treesitter
    -- is working.
    if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.cmd.normal("zx")
      end)
    else
      -- Else just fallback to using indentation.
      vim.wo[0][0].foldmethod = "indent"
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parsers = require("nvim-treesitter.parsers")
    ---@type ParserInfo
    parsers.prr = {
      install_info = {
        path = vim.fs.abspath("~/coding/tree-sitter-prr"),
        generate = false,
      },
    }
  end,
})
