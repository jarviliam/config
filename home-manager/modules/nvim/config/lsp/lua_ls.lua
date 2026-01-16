---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  on_init = function(client)
    -- Rely on conform
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        autoRequire = false,
        callSnippet = "Replace",
        keywordSnippet = "Both",
        workspaceWord = true,
      },
      diagnostics = {
        disable = {
          "inject-field",
          "missing-fields",
          "missing-parameter",
        },
        globals = {
          "LazyVim",
          "Snacks",
          "bit",
          "colors",
          "defaults",
          "describe",
          "ev",
          "hl",
          "it",
          "keys",
          "math",
          "ns",
          "package",
          "require",
          "vim",
        },
        unusedLocalExclude = {
          "_*",
        },
      },
      doc = {
        privateName = { "^_" },
      },
      format = {
        enable = false,
      },
      hint = {
        arrayIndex = "Disable",
        enable = true,
        paramName = "Disable",
        paramType = true,
        semicolon = "Disable",
        setType = true,
      },
      hover = {
        expandAlias = false,
      },
      runtime = {
        version = "LuaJIT",
      },
      telemetry = {
        enable = false,
      },
      type = {
        castNumberToInteger = true,
        inferParamType = true,
        checkTableShape = true,
      },
    },
  },
  root_markers = {
    ".luacheckrc",
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "lazy-lock.json",
    "selene.toml",
    "selene.yml",
    "stylua.toml",
    "lua/",
    ".git",
  },
  single_file_support = true,
}
