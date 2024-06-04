local go_config = {
  {
    type = "go",
    name = "Scanner-Worker",
    mode = "remote",
    substitutePath = {
      {
        from = "${workspaceFolder}",
        to = "/debug/",
      },
      {
        from = "/Users/liam.jarvis/go/pkg/",
        to = "/go/pkg/",
      },
    },
    request = "attach",
    port = 40001,
  },
  {
    type = "go",
    name = "Upload-Worker Attach",
    mode = "remote",
    request = "attach",
    substitutePath = {
      {
        from = "${workspaceFolder}",
        to = "/debug/",
      },
      {
        from = "/Users/liam.jarvis/go/pkg/",
        to = "/go/pkg/",
      },
    },
    port = 40000,
  },
  {
    type = "go",
    name = "Debug octopus server folder",
    request = "launch",
    program = "${workspaceFolder}/service/octopus-api/cmd/octopus-api",
    cwd = "${workspaceFolder}",
    showLog = true,
    args = { "server" },
  },
}

local lua_config = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "nvim-neotest/nvim-nio",
      },
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
      config = function(_, opts)
        require("dapui").setup(opts)
      end,
    },
    { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
    "leoluz/nvim-dap-go",
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        local get_python_path = function()
          local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          if venv_path then
            return venv_path .. "/bin/python"
          end
          return nil
        end
        local dap = require("dap-python")
        dap.setup(get_python_path())
        dap.test_runner = "pytest"
      end,
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      keys = {
        {
          "<leader>dl",
          function()
            require("osv").launch({ port = 8086 })
          end,
          desc = "Launch Lua adapter",
        },
      },
    },
  },
  lazy = true,
  keys = {
    { "<Space>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
    { "<Space>dB", "<cmd>FzfLua dap_breakpoints<cr>", desc = "List Breakpoint" },
    {
      "<Space>dc",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Set Breakpoint",
    },
    { "<F5>", "<cmd>DapContinue<cr>", desc = "Continue" },
    { "<Space>df", "<cmd>lua require 'dapui'.toggle()<CR>", desc = "Toggle" },
  },
  config = function()
    local dap = require("dap")
    require("dap-go").setup({
      dap_configurations = go_config,
    })
    dap.listeners.after.event_stopped["jarviliam"] = function()
      vim.keymap.set("n", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.hover()<CR>", { desc = "Hover" })
      vim.keymap.set("v", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.visual_hover()<CR>")
      vim.keymap.set("n", "<leader>dj", dap.step_into, { desc = "dap: Step Into" })
      vim.keymap.set("n", "<leader>dl", dap.step_over, { desc = "dap: Step Over" })
      vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = "dap: Step Out" })
      vim.keymap.set("n", "<leader>dn", dap.run_to_cursor, { desc = "dap: Run To Cursor" })
    end

    require("overseer").patch_dap(true)
    require("dap.ext.vscode").json_decode = require("overseer.json").decode

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.configurations["lua"] = lua_config

    -- C configurations.
    dap.adapters.codelldb = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    -- Add configurations from launch.json
    require("dap.ext.vscode").load_launchjs(nil, {
      ["codelldb"] = { "c" },
    })
  end,
}
