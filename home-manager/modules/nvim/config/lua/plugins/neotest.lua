return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
    },
    opts = {
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
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters

        require("neotest").setup(opts)
      end
    end,
    -- stylua: ignore
    keys = {
    { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    },
  },
  { "fredrikaverpil/neotest-golang" },
  { "nvim-neotest/neotest-jest" },
  { "marilari88/neotest-vitest" },
  { "nvim-neotest/neotest-plenary" },
  { "nvim-neotest/neotest-python" },
}
