local dap = require("dap")
local dapgo = require("dap-go")
if not dap.adapters.go then
  dapgo.setup({
    dap_configurations = {
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
