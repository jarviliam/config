return {
  { "mfussenegger/nvim-dap-python" },
  { "jbyuki/one-small-step-for-vimkind" },
  { "leoluz/nvim-dap-go" },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
      {
        "igorlfs/nvim-dap-view",
        opts = {
          winbar = {
            sections = { "scopes", "breakpoints", "threads", "exceptions", "repl", "console" },
            default_section = "scopes",
          },
          windows = { height = 18 },
        },
      },
    },
    lazy = true,
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<F5>",       "<cmd>DapContinue<cr>",                                                               desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                      desc = "Debug Nearest" },
      { "<leader>fdb", function() require("fzf-lua").dap_breakpoints() end,                      desc = "Dap BreakPoints" },
      { "<leader>fdv", function() require("fzf-lua").dap_variables() end,                      desc = "Dap Vars" },
    },
    config = function()
      local dap = require("dap")
      local dv = require("dap-view")

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

      require("overseer").patch_dap(true)
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
    end,
  },
}
