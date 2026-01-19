vim.filetype.add({
  extension = {
    prr = "prr",
    hujson = "json5",
    smd = "supermd",
    shtml = "superhtml",
    ziggy = "ziggy",
    ["ziggy-schema"] = "ziggy_schema",
  },
  filename = {
    [".envrc"] = "direnv",
  },
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
