Config.later(function()
  vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/igorlfs/nvim-dap-view",

    "https://github.com/mfussenegger/nvim-dap-python",
    "https://github.com/jbyuki/one-small-step-for-vimkind",
    "https://github.com/leoluz/nvim-dap-go",
  }, { load = true })

  local dap = require("dap")
  local dv = require("dap-view")

  dv.setup({
    winbar = {
      sections = { "scopes", "breakpoints", "threads", "exceptions", "repl", "console" },
      default_section = "scopes",
    },
  })

  dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
  end
  dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
  end
  dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
  end

  require("dap.ext.vscode").json_decode = require("overseer.json").decode
end)
