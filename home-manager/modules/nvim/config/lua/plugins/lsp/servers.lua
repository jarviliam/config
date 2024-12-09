local js_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    variableTypes = { enabled = true },
  },
}

return {
  bashls = {},
  cmake = {},
  clangd = {
    cmd = {
      "clangd",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=none",
    },
  },
  zls = {},
  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  golangci_lint_ls = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  },
  nil_ls = {
    settings = {
      ["nil"] = {
        testSetting = 42,
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
  },
  pyright = {
    init_options = { documentFormatting = false },
    before_init = function(params, config)
      if vim.env.VIRTUAL_ENV then
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. "/bin/python"
      end
    end,
  },
  lua_ls = {
    init_options = { documentFormatting = false },
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
          Lua = {
            format = {
              enable = false,
            },
            runtime = {
              version = "LuaJIT",
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              arrayIndex = "Disable",
            },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        })
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end,
  },
  ruff = {},
  rust_analyzer = {},
  terraformls = {},
  vtsls = {
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = js_settings,
      javascript = js_settings,
    },
  },
  yamlls = {
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        validate = true,
        hover = true,
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}
