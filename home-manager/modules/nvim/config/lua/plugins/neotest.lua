return {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
      "stevearc/overseer.nvim",
    },
    keys = {
      {
        "<leader>Tn",
        function()
          require("neotest").run.run({})
        end,
        desc = "Run test",
      },
      {
        "<leader>Tt",
        function()
          require("neotest").run.run({ vim.api.nvim_buf_get_name(0) })
        end,
        desc = "Run test buffer",
      },
      {
        "<leader>Ta",
        function()
          for _, adapter_id in ipairs(require("neotest").run.adapters()) do
            require("neotest").run.run({ suite = true, adapter = adapter_id })
          end
        end,
        desc = "Run test suite",
      },
      {
        "<leader>Tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>Td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Run test dap",
      },
      {
        "<leader>Ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test summary",
      },
      {
        "<leader>To",
        function()
          require("neotest").output.open({ short = true })
        end,
        desc = "Test output",
      },
    },
    config = function()
      local neotest = require("neotest")
      -- require("neotest.logging"):set_level("trace")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-plenary"),
          require("neotest-go"),
          require("neotest-jest")({
            jestCommand = "yarn test",
            cwd = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src")
              end
              return vim.fn.getcwd()
            end,
          }),
        },
        discovery = {
          enabled = false,
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        summary = {
          mappings = {
            attach = "a",
            expand = "l",
            expand_all = "L",
            jumpto = "gf",
            output = "o",
            run = "<C-r>",
            short = "p",
            stop = "u",
          },
        },
        icons = {
          passed = " ",
          running = " ",
          failed = " ",
          unknown = " ",
          running_animated = vim.tbl_map(function(s)
            return s .. " "
          end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
        },
        diagnostic = {
          enabled = true,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        status = {
          enabled = true,
        },
      })
    end,
  }
