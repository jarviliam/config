return require("schema-companion").setup_client(
  require("schema-companion").adapters.yamlls.setup({
    sources = {
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
      require("schema-companion").sources.lsp.setup(),
      require("schema-companion").sources.schemas.setup({
        {
          name = "Kubernetes master",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
        },
      }),
      require("schema-companion").sources.none.setup(),
    },
  }),
  {
    cmd = { "yaml-language-server", "--stdio" },
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = true
      client.config.settings.yaml.schemas = require("schemastore").yaml.schemas()
      client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end,
    filetypes = { "yaml", "yaml.github" },
    settings = {
      flags = {
        debounce_text_changes = 50,
      },
      redhat = { telemetry = { enabled = false } },
      yaml = {
        completion = true,
        editor = {
          formatOnType = true,
        },
        format = {
          enable = true,
          singleQuote = false,
        },
        hover = true,
        schemas = {},
        schemaStore = {
          enable = false,
          url = "",
        },
        validate = true,
      },
    },
  }
)
