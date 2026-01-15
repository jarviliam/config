Config.later(function()
  vim.pack.add({
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/antoinemadec/FixCursorHold.nvim",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/fredrikaverpil/neotest-golang",
    "https://github.com/nvim-neotest/neotest-jest",
    "https://github.com/nvim-neotest/neotest-plenary",
    "https://github.com/nvim-neotest/neotest-python",
  }, { load = true })

  local nt = require("neotest")

  nt.setup({
    adapters = {
      ["neotest-golang"] = {
        dap_go_enabled = true,
      },
      ["neotest-vitest"] = {},
      ["neotest-jest"] = {
        jestCommand = "yarn test",
        cwd = function(file)
          return string.find(file, "/packages/") and string.match(file, "(.-/[^/]+/)src") or vim.fn.getcwd()
        end,
      },
      ["neotest-plenary"] = {},
      ["neotest-python"] = {},
    },
    status = { virtual_text = true },
    output = { open_on_run = true },
    discovery = {
      enabled = true,
    },
    running = {
      concurrent = true,
    },
  })
end)
