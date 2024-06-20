local diagnostic_icons = require("icons").diagnostics

return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mfussenegger/nvim-lsp-compl",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      require("lspconfig.ui.windows").default_options.border = "rounded"

      local function capabilities()
        return vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("lsp_compl").capabilities()
        )
      end

      for severity, icon in pairs(diagnostic_icons) do
        local hl = "DiagnosticSign" .. severity:sub(1, 1) .. severity:sub(2):lower()
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = "",
          format = function(diagnostic)
            local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
            local message = vim.split(diagnostic.message, "\n")[1]
            return string.format("%s %s ", icon, message)
          end,
        },
        signs = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = true,
          source = "if_many",
          border = "rounded",
        },
      })
      for server, opts in pairs(require("plugins.lsp.servers")) do
        local options = {
          capabilities = capabilities(),
        }
        opts = vim.tbl_deep_extend("force", {}, options, opts or {})
        lspconfig[server].setup(opts)
      end
    end,
  },
}
