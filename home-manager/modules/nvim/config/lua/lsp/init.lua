local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

-- Setup icons
require("lsp.diag")
require("lsp.icons")

-- Enable border for hover/signature
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local servers = {
  bashls = {},
  clangd = {},
  jsonls = {},
  gopls = {},
  nil_ls = {},
  pyright = {
    before_init = function(params, config)
      local Path = require("plenary.path")
      local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
      if venv:joinpath("bin"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
      else
        config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
      end
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  rust_analyzer = {},
  terraformls = {},
  tsserver = {},
  ruff_lsp = {},
  yamlls = {
    schemas = {
      kubernetes = "globPattern",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
    },
    keyOrdering = false,
  },
}
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- enables snippet support
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- enables LSP autocomplete
  local cmp_loaded, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_loaded then
    capabilities = cmp_lsp.default_capabilities()
  end
  return {
    on_attach = require("lsp.attach").on_attach,
    capabilities = capabilities,
  }
end

local function is_installed(cfg)
  local cmd = cfg.document_config and cfg.document_config.default_config and cfg.document_config.default_config.cmd
    or nil
  -- server binary is executable within neovim's PATH
  return cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1
end

for srv, s_cfg in pairs(servers) do
  local cfg = make_config()
  cfg = vim.tbl_deep_extend("force", s_cfg, cfg)
  if is_installed(lspconfig[srv]) then
    lspconfig[srv].setup(cfg)
  end
end
