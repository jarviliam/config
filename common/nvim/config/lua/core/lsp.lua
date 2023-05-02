require("modules.lsp.diagnostics").setup()

local function on_attach(client, bufnr)
  require("modules.lsp.format").setup(client, bufnr)
  require("modules.lsp.keys").setup(client, bufnr)

  if client.name == "typescript" or client.name == "tsserver" then
    local ts = require("nvim-lsp-ts-utils")
    ts.setup({
      disable_commands = false,
      enable_import_on_completion = false,
      import_on_completion_timeout = 5000,
      eslint_bin = "eslint_d", -- use eslint_d if possible!
      eslint_enable_diagnostics = true,
      eslint_enable_disable_comments = true,
    })
    ts.setup_client(client)
  end
end

local yaml = {
  schemaStore = {
    enable = true,
    url = "https://www.schemastore.org/api/json/catalog.json",
  },
  schemas = {
    kubernetes = "*.yaml",
    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
  },
  format = { enabled = false },
  validate = false, -- TODO: conflicts between Kubernetes resources and kustomization.yaml
  completion = true,
  hover = true,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("neodev").setup()

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    yaml = yaml,
  },
}

local servers = {
  bashls = {},
  clangd = {},
  dockerls = {},
  jsonls = {},
  gopls = {},
  rnix = {},
  pyright = {
    before_init = function(params, config)
      local Path = require("plenary.path")
      local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
      if venv:joinpath("bin"):is_dir() then
        config.settings.python.pythonPath =
            tostring(venv:joinpath("bin", "python"))
      else
        config.settings.python.pythonPath =
            tostring(venv:joinpath("Scripts", "python.exe"))
      end
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  rust_analyzer = {},
  terraformls = {},
  tsserver = {},
  yamlls = {},
}

require("modules.lsp.null").setup(options)
local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  for k, v in pairs(config) do
    options[k] = v
  end
  lspconfig[server].setup(options)
end
