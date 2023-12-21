return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        {
          "<leader>de",
          function()
            require("dapui").eval()
            require("dapui").eval()
          end,
          desc = "Evaluate expression",
        },
      },
      opts = {
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
        floating = {
          border = "rounded",
        },
        layouts = {
          {
            elements = {
              { id = "stacks", size = 0.30 },
              { id = "breakpoints", size = 0.20 },
              { id = "scopes", size = 0.50 },
            },
            position = "left",
            size = 40,
          },
        },
      },
    },
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
    "jbyuki/one-small-step-for-vimkind",
  },
  lazy = true,
  keys = {
    { "<Space>db", "<cmd>DapToggleBreakpoint<cr>", desc = "dap: Toggle Breakpoint" },
    { "<Space>dB", "<cmd>FzfLua dap_breakpoints<cr>", desc = "dap: List Breakpoint" },
    { "<Space>dc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" },
    { "<F5>", "<cmd>DapContinue<cr>", desc = "dap: Continue" },
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
