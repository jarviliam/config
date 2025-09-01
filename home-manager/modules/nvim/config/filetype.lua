vim.filetype.add({
  extension = {
    prr = "prr",
  },
  filename = {
    [".envrc"] = "direnv",
  },
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
