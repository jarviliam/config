vim.api.nvim_exec(
  [[
augroup vimrc -- Ensure all autocmds are cleared
autocmd!
augroup end
]] ,
  ""
)

local cursorLineGroup =
vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
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

local YankGroup =
vim.api.nvim_create_augroup("TextYankHighlight", { clear = true })

-- Highlight Yank. * is default
vim.api.nvim_create_autocmd("TextYankPost", {
  group = YankGroup,
  callback = function()
    vim.highlight.on_yank({
      timeout = 500,
    })
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

local clearCommands =
vim.api.nvim_create_augroup("ClearCommandMessages", { clear = true })
vim.api.nvim_create_autocmd({ "CmdlineLeave", "CmdlineChanged" }, {
  group = clearCommands,
  pattern = ":",
  callback = clear_cmd(),
})

as.augroup("VimrcIncSearchHighlight", {
  {
    events = { "CmdlineEnter" },
    targets = { "[/\\?]" },
    command = ":set hlsearch  | redrawstatus",
  },
  {
    events = { "CmdlineLeave" },
    targets = { "[/\\?]" },
    command = ":set nohlsearch | redrawstatus",
  },
})

as.augroup("ExternalCommands", {
  {
    events = { "BufEnter" },
    targets = { "*.png,*.jpg,*.gif" },
    command = function()
      vim.cmd(
        string.format(
          'silent! "%s | :bw"',
          vim.g.open_command .. " " .. vim.fn.expand("%")
        )
      )
    end,
  },
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
    local is_readonly = (vim.bo.readonly or not vim.bo.modifiable)
        and vim.fn.hasmapto("q", "n") == 0

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
  { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
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
