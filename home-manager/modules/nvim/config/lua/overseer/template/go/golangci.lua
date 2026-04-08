return {
  name = "Run GolangCI",
  builder = function()
    return {
      cmd = { "golangci-lint" },
      args = { "run", "./..." },
      name = "GolangCI",
      components = {
        {
          "on_output_quickfix",
          errorformat = [[%A%f:%l:%c: %m,%-G%.%#]],
          open = true,
          set_diagnostics = true,
        },
        "default",
      },
    }
  end,
  priority = 10,
  condition = {
    filetype = { "go", "gomod" },
  },
}
