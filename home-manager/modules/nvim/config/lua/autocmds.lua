local augroup = vim.api.nvim_create_augroup("JAutoCmd", {})
vim.api.nvim_create_autocmd("TextYankPost",
    {
        group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
        desc = "Highlight on Yank",
        callback = function()
            vim.highlight.on_yank({ higroup = 'Visual', priority = 250 })
        end
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
    pattern = { "help",
        "qf",
        "man",
        "Scratch",
        "netrw",
        "tsplayground",
        "git-status",
        "dap-float",
        "codelldb",
        "repl", },
    callback = function(args)
        vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = args.buf })
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
