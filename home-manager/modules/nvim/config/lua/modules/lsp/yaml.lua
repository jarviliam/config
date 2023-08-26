local server = "yaml-language-server"

if vim.fn.executable(server) == 0 then
  vim.api.nvim_err_writeln(string.format("lsp-server: %q is not installed", server))
  return
end

require("core.lsp").setup("yamlls")
