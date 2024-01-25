local efm_languages = {
    go = { require("efmls-configs.formatters.gofmt"), require("efmls-configs.linters.golangci_lint") },
    python = { require("efmls-configs.formatters.ruff"), require("efmls-configs.linters.ruff") },
    lua = { require("efmls-configs.formatters.stylua"), require("efmls-configs.linters.luacheck") },
    nix = { require("efmls-configs.formatters.nixfmt") },
    terraform = { require("efmls-configs.formatters.terraform_fmt") },
    yaml = {
        require("efmls-configs.formatters.prettier_d"),
        require("efmls-configs.linters.actionlint"),
        require("efmls-configs.linters.yamllint"),
    },
}
for _, filetype in ipairs({ "javascript", "typescript", "html", "css", "scss", "less", "json", "jsonc" }) do
    efm_languages[filetype] = { require("efmls-configs.formatters.prettier_d") }
end

return {
    efm = {
        init_options = { documentFormatting = true, documentRangeFormatting = true },
        settings = {
            rootMarkers = { ".git/" },
            languages = vim.tbl_keys(efm_languages),
        },
    },
    bashls = {},
    cmake={},
    clangd = {
        offsetEncoding = { "utf-16", "utf-8" }
    },
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
                        completion = {
                            callSnippet = "Replace"
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                "${3rd}/luv/library",
                                "${3rd}/busted/library",
                            },
                        },
                    },
                })

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
        end,
    },
    ruff_lsp = {},
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
