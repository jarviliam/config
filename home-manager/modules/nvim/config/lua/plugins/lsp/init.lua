local diagnostic_icons = require("icons").diagnostics
return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "ray-x/lsp_signature.nvim",
    "folke/neodev.nvim",
    {
    "j-hui/fidget.nvim",
    tag = "v1.1.0",
  },
  },
  config = function()
    require("neodev").setup({})
    require("fidget").setup({
      text = {
        spinner = "circle_halves",
      },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local completion = require("cmp_nvim_lsp").default_capabilities(capabilities)

    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    capabilities.textDocument.completion = completion.textDocument.completion
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

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

    -- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
    local show_handler = vim.diagnostic.handlers.virtual_text.show
    local hide_handler = vim.diagnostic.handlers.virtual_text.hide
    vim.diagnostic.handlers.virtual_text = {
      show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2)
          return diag1.severity > diag2.severity
        end)
        return show_handler(ns, bufnr, diagnostics, opts)
      end,
      hide = hide_handler,
    }

    for server, opts in pairs(require("plugins.lsp.servers")) do
      local options = {
        capabilities = capabilities,
        on_attach = require("plugins.lsp.on_attach")(opts),
        flags = {
          debounce_text_changes = 150,
        },
      }
      opts = vim.tbl_deep_extend("force", {}, options, opts or {})
      require("lspconfig")[server].setup(opts)
    end
  end,
}
