local ok, dap = as.safe_require("dap")
if not ok then
  return
end
require("dap-go").setup({
  dap_configurations = {
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
  },
  delve = {
    initialize_timeout_sec = 20,
    port = "${port}",
  },
})
