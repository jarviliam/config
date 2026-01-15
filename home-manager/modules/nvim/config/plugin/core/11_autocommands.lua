local gr = vim.api.nvim_create_augroup("config", {})

_G.Config.new_autocmd = function(event, opts)
  opts.group = opts.group or gr
  vim.api.nvim_create_autocmd(event, opts)
end

--- Create User Command
---@param name string
---@param callback string | fun(args: vim.api.keyset.create_user_command.command_args)
---@param opts vim.api.keyset.user_command
_G.Config.new_cmd = function(name, callback, opts)
  vim.api.nvim_create_user_command(name, callback, opts)
end

--- Create a floating window via snacks
---@param options table
---@param lines string[]
vim.ui.float = function(options, lines)
  ---@param self snacks.win
  local on_buf = function(self)
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  end
  return Snacks.win.new(vim.tbl_deep_extend("force", {}, options or {}, { on_buf = on_buf }))
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
Config.new_autocmd(
  { "CmdlineLeave", "CmdlineChanged" },
  { pattern = ":", callback = clear_cmd, desc = "Clear command line" }
)

Config.new_autocmd("FileType", {
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
  callback = function(e)
    vim.bo[e.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = e.buf, silent = true })
  end,
  desc = "Close with q.",
})

Config.new_autocmd("FileType", {
  pattern = { "man" },
  callback = function(e)
    vim.bo[e.buf].buflisted = false
  end,
  desc = "Easier inline man-files closing",
})

Config.new_autocmd("FileType", {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "Conceal Json files",
})

Config.new_autocmd("BufReadPost", {
  desc = "Go to the last location when opening a buffer",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

Config.new_cmd("Todos", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = " TODOs", nargs = 0 })

Config.new_cmd("Jq", function()
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(buf_lines, "\n")

  local output = vim.fn.systemlist("jq .", input)
  if vim.v.shell_error ~= 0 then
    vim.print(output)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, { desc = "Run JQ" })
