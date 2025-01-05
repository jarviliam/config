local dap = require("dap")
local dapgo = require("dap-go")

local function get_arguments()
  return coroutine.create(function(dap_run_co)
    local args = {}
    vim.ui.input({ prompt = "Args: " }, function(input)
      args = vim.split(input or "", " ")
      coroutine.resume(dap_run_co, args)
    end)
  end)
end
if not dap.adapters.go then
  dapgo.setup({
    dap_configurations = {
      {
        type = "go",
        name = "Debug Package (Args)",
        request = "launch",
        program = "${fileDirname}",
        args = get_arguments,
      },
      {
        type = "go",
        name = "Debug octopus server folder",
        request = "launch",
        program = "${workspaceFolder}/service/octopus-api/cmd/octopus-api",
        cwd = "${workspaceFolder}",
        args = { "server" },
      },
      {
        type = "go",
        name = "Debug octopus worker folder",
        request = "launch",
        program = "${workspaceFolder}/service/octopus-api/cmd/octopus-api",
        cwd = "${workspaceFolder}",
        args = { "worker" },
      },
    },
  })
end

if not vim.g._loaded_goplements then
  require("goplements").setup()
  vim.g._loaded_goplements = 1
end
