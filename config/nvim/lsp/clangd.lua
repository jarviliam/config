---@type vim.lsp.Config
return {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--offset-encoding=utf-8" },
  filetypes = { "c", "cpp" },
  init_options = {
    clangdFileStatus = true,
    completeUnimported = true,
    usePlaceholders = true,
    semanticHighlighting = true,
  },
  on_attach = function() end,
  root_markers = {
    ".clangd",
    "Makefile",
    "build.ninja",
    "compile_commands.json",
    "configure.in",
    "meson.build",
  },
  settings = {
    clangd = {
      semanticHighlighting = true,
      single_file_support = false,
    },
  },
  single_file_support = true,
}
