return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "ray-x/lsp_signature.nvim",
    "folke/neodev.nvim",
    "SmiteshP/nvim-navic",
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
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true

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
    -- require("modules.lsp.null").setup()
    -- require("lsp")
  end,
}
