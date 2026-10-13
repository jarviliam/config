Config.later(function()
  vim.pack.add({
    "https://github.com/stevearc/overseer.nvim",
  }, { load = true })

  local ov = require("overseer")
  ov.setup({
    templates = {
      "builtin",
      "go",
    },
    component_aliases = {
      default_neotest = {
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        "on_complete_dispose",
      },
    },
    dap = true,
    form = {
      win_opts = { winblend = 0 },
    },
    confirm = {
      win_opts = { winblend = 5 },
    },
    task_win = {
      win_opts = { winblend = 0 },
    },
  })
end)
