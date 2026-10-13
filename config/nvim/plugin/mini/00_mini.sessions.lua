Config.now(function()
  require("mini.sessions").setup({
    -- Whether to read default session if Neovim opened without file arguments
    autoread = false,

    -- Whether to write currently read session before leaving it
    autowrite = true,

    -- Directory where global sessions are stored (use `''` to disable)
    --minidoc_replace_start directory = --<"session" subdir of user data directory from |stdpath()|>,
    directory = vim.fn.stdpath("data") .. "/session",
    --minidoc_replace_end

    -- File for local session (use `''` to disable)
    file = "Session.vim",

    -- Whether to force possibly harmful actions (meaning depends on function)
    force = { read = false, write = true, delete = false },

    -- Hook functions for actions. Default `nil` means 'do nothing'.
    -- Takes table with active session data as argument.
    hooks = {
      -- Before successful action
      pre = { read = nil, write = nil, delete = nil },
      -- After successful action
      post = { read = nil, write = nil, delete = nil },
    },

    -- Whether to print session path after action
    verbose = { read = false, write = true, delete = true },
  })
end)
