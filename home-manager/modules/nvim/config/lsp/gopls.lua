---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      completeUnimported = true,
      directoryFilters = {
        "-.git",
        "-.vscode",
        "-.idea",
        "-.vscode-test",
        "-node_modules",
        "-**/node_modules",
      },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
