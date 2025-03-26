---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  -- on_new_config = function(config)
  --   config.settings = vim.tbl_deep_extend("force", config.settings, {
  --     yaml = { schemas = require("schemastore").yaml.schemas() },
  --   })
  -- end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      validate = true,
      hover = true,
      schemas = {
        -- GitHub CI workflows
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}
