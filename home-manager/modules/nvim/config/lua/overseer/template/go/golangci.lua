return {
  name = "Run GolangCI",
  builder = function()
    return {
      cmd = { "golangci-lint" },
      args = { "run", "./..." },
      name = "GolangCI",
      components = {
        "on_exit_set_status",
        {
          "on_output_parse",
          problem_matcher = {
            owner = "golangci-lint",
            fileLocation = { "relative", "${workspaceFolder}" },
            severity = "error",
            pattern = {
              regexp = "^([^:]+):([0-9]+):([0-9]+):",
              file = 1,
              line = 2,
              column = 3,
            },
          },
        },
        { "on_output_quickfix", items_only = true, set_diagnostics = true },
      },
    }
  end,
  priority = 10,
  condition = {
    filetype = { "go", "gomod" },
  },
}
