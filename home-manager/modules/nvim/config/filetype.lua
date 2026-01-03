vim.filetype.add({
  extension = {
    prr = "prr",
    hujson = "json5",
  },
  filename = {
    [".envrc"] = "direnv",
  },
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
