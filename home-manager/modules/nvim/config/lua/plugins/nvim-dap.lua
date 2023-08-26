return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
  },
  lazy = true,
  keys = {
    { "<Space>d~", "<cmd>DapToggleBreakpoint<cr>", desc = "dap: Toggle Breakpoint" },
    { "<Space>d-", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" },
    { "<Space>do", "<cmd>DapContinue<cr>", desc = "dap: Continue" },
    { "<Space>df", "<cmd>lua require 'dapui'.toggle()<CR>", desc = "dapui: Toggle" },
  },
  config = function()
    local lang = {
      "cpp",
      "go",
      "go_test",
      "python",
      "node",
      "lua",
    }
    for _, l in pairs(lang) do
      local fname = string.format("modules.dap.%s", l)
      require(fname)
    end
    local dapui = require("dapui")
    local dap_icons = {
      breakpoint = " ",
      breakpoint_condition = " ",
      log_point = " ",
      stopped = " ",
      breakpoint_rejected = " ",
      pause = " ",
      play = " ",
      step_into = " ",
      step_over = " ",
      step_out = " ",
      step_back = " ",
      run_last = " ",
      terminate = " ",
    }
    dapui.setup({
      icons = {
        collapsed = " ",
        expanded = " ",
        current = " ",
        folder_empty = "",
        folder_closed = "",
        folder_open = "",
        file = "",
        v_border = "▐",
      },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },

      -- Use this to override mappings for specific elements
      element_mappings = {
        -- Example:
        -- stacks = {
        --   open = "<CR>",
        --   expand = "o",
        -- }
      },

      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7") == 1,

      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },

      controls = {
        enabled = true,
        element = "repl",
        icons = dap_icons,
      },

      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },

      windows = { indent = 1 },

      render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      },
    })
    local dap = require("dap")
    dap.listeners.after.event_stopped["jarviliam"] = function()
      vim.keymap.set("n", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.hover()<CR>")
      vim.keymap.set("v", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.visual_hover()<CR>")
      vim.keymap.set("n", "<leader>dj", dap.step_into, { desc = "dap: Step Into" })
      vim.keymap.set("n", "<leader>dl", dap.step_over, { desc = "dap: Step Over" })
      vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = "dap: Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "dap: Restart" })
      vim.keymap.set("n", "<leader>dn", dap.run_to_cursor, { desc = "dap: Run To Cursor" })
    end
    require("nvim-dap-virtual-text").setup({
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = false, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })
    vim.fn.sign_define("DapBreakpoint", { text = dap_icons.breakpoint, texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = dap_icons.breakpoint_condition, texthl = "", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = dap_icons.log_point, texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = dap_icons.stopped, texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = dap_icons.breakpoint_rejected, texthl = "", linehl = "", numhl = "" }
    )
  end,
}
