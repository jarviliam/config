---@type vim.lsp.Config
return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  cmd = { "github-actions-languageserver", "--stdio" },
  filetypes = { "yaml.github" },
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx)
      result.diagnostics = vim.tbl_filter(function(diagnostic)
        -- silence annoying context warnings https://github.com/github/vscode-github-actions/issues/222
        if
          diagnostic.severity == vim.diagnostic.severity.WARN
          and diagnostic.message:match("Context access might be invalid:")
        then
          return false
        end

        return true
      end, result.diagnostics)
      vim.lsp.handlers[ctx.method](err, result, ctx)
    end,
  },
  root_markers = { ".github" },
  init_options = {
    sessionToken = vim.env.GITHUB_API_TOKEN,
  },
  single_file_support = true,
}
