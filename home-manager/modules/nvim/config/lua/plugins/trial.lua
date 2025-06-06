return {
  {
    "nvim-neorg/neorg",
    enabled = false,
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
        -- stylua: ignore
        { "<leader>xx", function() require("trouble").toggle({ mode = "diagnostics" }) end, desc = "Trouble" },
    },
    opts = {
      auto_preview = false,
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
  },
}
