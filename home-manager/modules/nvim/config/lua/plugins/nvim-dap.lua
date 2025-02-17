local winID = nil
local D = {}

function D.goToWin() end
if winID ~= nil and vim.api.nvim_win_is_valid(winID) then
  vim.api.nvim_set_current_win(winID)
  return true
end
function D.Close()
  if winID == nil then
    return
  end
  if not vim.api.nvim_win_is_valid(winID) then
    winID = nil
    return
  end
  local tab = vim.api.nvim_tabpage_get_number(vim.api.nvim_win_get_tabpage(winID))
  require("dapui").close()
  vim.cmd.tabclose(tab)
end

function D.Open()
  if D.goToWin() then
    vim.notify(winID)
    return
  end
  vim.notify("New Window")
  vim.cmd.tabedit("%")
  vim.wo.scrolloff = 10
  winID = vim.fn.win_getid()
  require("dapui").open()
end

return {
  { "mfussenegger/nvim-dap-python" },
  { "jbyuki/one-small-step-for-vimkind" },
  { "leoluz/nvim-dap-go" },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
    },
    lazy = true,
    -- stylua: ignore
    keys = {
      { "<leader>d",  "",                                                                                   desc = "+debug",                 mode = { "n", "v" } },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<F5>",       "<cmd>DapContinue<cr>",                                                               desc = "Continue" },
      -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
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
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                      desc = "Debug Nearest" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str, {}))
      end
      require("overseer").enable_dap()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    lazy = true,
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      dap.defaults.switch_buf = "uselast"
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
      -- dap.listeners.before.event_stopped["dap-tab"] = D.Open
    end,
  },
}
