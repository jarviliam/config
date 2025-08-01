if vim.g._useTsgo == 0 then
  local common_settings = {
    suggest = { completeFunctionCalls = true },
    inlayHints = {
      functionLikeReturnTypes = { enabled = true },
      parameterNames = { enabled = "literals" },
      variableTypes = { enabled = true },
    },
  }
  ---@type vim.lsp.Config
  return {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "javascript.tsx", "typescript.tsx" },
    root_markers = { "jsconfig.json", "package.json", "tsconfig.json" },
    settings = {
      complete_function_calls = true,
      vtsls = {
        autoUseWorkspaceTsdk = true,
        enableMoveToFileCodeAction = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
          maxInlayHintLength = 30,
        },
      },
      typescript = common_settings,
      javascript = common_settings,
    },
    single_file_support = true,
  }
end
