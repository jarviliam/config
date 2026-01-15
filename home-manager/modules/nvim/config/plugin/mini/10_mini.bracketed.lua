Config.later(function()
  require("mini.bracketed").setup({
    buffer = { suffix = "" },
    file = { suffix = "" },
    diagnostic = { suffix = "" }, -- Built in.
    indent = { suffix = "" },
    jump = { suffix = "" },
    location = { suffix = "" },
    oldfile = { suffix = "" },
    quickfix = { suffix = "" },
    treesitter = { suffix = "" },
    undo = { suffix = "" },
    yank = { suffix = "" },
  })
end)
