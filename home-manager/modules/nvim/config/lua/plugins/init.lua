return {
  "nvim-lua/plenary.nvim",
  { "b0o/SchemaStore.nvim", version = false },
  { "tpope/vim-abolish", command = "S" },
  { "sainnhe/everforest" },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_background = "soft" -- soft, medium, hard
      vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
      vim.g.gruvbox_material_statusline_style = "material"
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_menu_selection_backgrouund = "colored"
    end,
    lazy = true,
  },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        style = "multiplex",
      })
    end,
  },
  { "projekt0n/github-nvim-theme" },
}
