---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  handlers = {
    ["yaml/schema/store/initialized"] = function(...)
      require("schema-companion.lsp").store_initialized(...)
    end,
  },
  on_new_config = function(config)
    config.settings = vim.tbl_deep_extend("force", config.settings, {
      yaml = { schemas = require("schemastore").yaml.schemas() },
    })
  end,
  --- @param client vim.lsp.Client
  --- @param bufnr integer
  on_attach = function(client, bufnr)
    local context = require("schema-companion.context")
    context.setup(bufnr, client)
  end,
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
