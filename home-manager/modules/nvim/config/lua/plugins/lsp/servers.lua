local prettierd = {
  formatCommand = "prettierd ${INPUT}",
  formatStdin = true,
  env = {
    string.format("PRETTIERD_DEFAULT_CONFIG=%s/.prettierrc.json", vim.fn.getcwd()),
  },
}

return {
  efm = {
    init_options = { documentFormatting = true },
    settings = {
      rootMarkers = { ".git/" },
      languages = {
        ["lua"] = {
          {
            formatCommand = "stylua --color Never -",
            formatStdin = true,
            rootMarkers = { "stylua.toml", ".stylua.toml" },
          },
        },
        ["go"] = {
          {
            formatCommand = "gofmt",
            formatStdin = true,
          },
          {
            formatCommand = "goimports",
            formatStdin = true,
          },
        },
        ["nix"] = {
          {
            formatCommand = "nixfmt",
            formatStdin = true,
            rootMarkers = {
              "flake.nix",
              "shell.nix",
              "default.nix",
            },
          },
        },
        ["python"] = {
          {
            formatCommand = "black --no-color -q -",
            formatStdin = true,
          },
          {
            formatCommand = "ruff --fix -e -n -",
            formatStdin = true,
          },
        },
        ["javascript"] = { prettierd },
        ["javascriptreact"] = { prettierd },
        ["javascript.jsx"] = { prettierd },
        ["typescript"] = { prettierd },
        ["typescriptreact"] = { prettierd },
        ["typescript.tsx"] = { prettierd },
        ["terraform"] = {
          {
            formatCommand = "terraform fmt -",
            formatStdin = true,
          },
        },
        ["yaml"] = {
          {
            prefix = "actionlint",
            lintCommand = "actionlint -no-color -onelone ${INPUT} -",
            lintStdin = true,
            lintFormats = {
              "%f:%l:%c: %.%#: SC%n:%trror:%m",
              "%f:%l:%c: %.%#: SC%n:%tarning:%m",
              "%f:%l:%c: %.%#: SC%n:%tnfo:%m",
              "%f:%l:%c: %m",
            },
            requireMarker = true,
            rootMarkers = { ".github/" },
          },
        },
      },
    },
  },
  bashls = {},
  clangd = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  gopls = {
    settings = {
      analyses = {
        unusedparams = true,
        nillness = true,
        unusedwrites = true,
        useany = true,
        unusedvariable = true,
      },
      completeUnimported = true,
      staticcheck = true,
      buildFlags = { "-tags=integration,e2e" },
      linksInHover = true,
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
        run_vulncheck_exp = true,
        upgrade_dependency = true,
      },
      usePlaceholders = true,
      directoryFilters = {
        "-**/node_modules",
        "-/tmp",
      },
      completionDocumentation = true,
      deepCompletion = true,
      semanticTokens = true,
      verboseOutput = false, -- useful for debugging when true.
      matcher = "Fuzzy", -- default
      diagnosticsDelay = "500ms",
      symbolMatcher = "Fuzzy", -- default is FastFuzzy
    },
  },
  nil_ls = {},
  pyright = {
    init_options = { documentFormatting = false },
    before_init = function(params, config)
      local Path = require("plenary.path")
      local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
      if venv:joinpath("bin"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
      else
        config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
      end
      local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
      if match ~= "" then
        local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
        vim.env.VIRTUAL_ENV = poetry_venv
      end
    end,
  },
  lua_ls = {
    init_options = { documentFormatting = false },
    settings = {
      Lua = {
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            quote_style = "AutoPreferDouble",
            call_parentheses = "Always",
            column_width = "120",
            line_endings = "Unix",
          },
        },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        diagnostics = {
          enable = true,
          neededFileStatus = {
            ["codestyle-check"] = "Any",
          },
          globals = { "vim", "hs" },
        },
      },
    },
  },
  rust_analyzer = {},
  terraformls = {},
  tsserver = {
    init_options = {
      documentFormatting = false,
      hostInfo = "neovim",
    },
  },
  yamlls = {
    schemaStore = {
      enable = false,
      url = "",
    },
    schemas = require("schemastore").yaml.schemas(),
    keyOrdering = false,
  },
}
