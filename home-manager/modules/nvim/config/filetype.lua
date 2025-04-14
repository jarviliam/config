vim.filetype.add({
  filename = {
    [".envrc"] = "direnv",
  },
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
