return {
  "nvim-lua/plenary.nvim",
  { "b0o/SchemaStore.nvim", version = false },
  {
    "echasnovski/mini.icons",
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    lazy = false,
    opts = {
      glyph = true,
    },
  },
  {
    "m4xshen/hardtime.nvim",
    command = "Hardtime",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", { "nvim-lua/plenary.nvim", lazy = true } },
    opts = {
      max_time = 1000,
      max_count = 3,
      disable_mouse = 3,
      hint = true,
      allow_different_keys = true,
      restricted_keys = {
        ["-"] = {},
        ["<C-M>"] = {},
        ["<C-N>"] = {},
        ["<C-P>"] = {},
        ["<CR>"] = {},
      },
      resetting_keys = {
        ["s"] = {},
        ["S"] = {},
      },
      disabled_keys = {
        ["<CR>"] = {},
      },
      disabled_filetypes = {
        "NvimTree",
        "TelescopePrompt",
        "aerial",
        "alpha",
        "checkhealth",
        "dapui*",
        "Diffview*",
        "Dressing*",
        "help",
        "httpResult",
        "lazy",
        "lspinfo",
        "Neogit*",
        "mason",
        "neotest%-summary",
        "minifiles",
        "neo%-tree*",
        "netrw",
        "noice",
        "notify",
        "prompt",
        "qf",
        "query",
        "oil",
        "undotree",
        "trouble",
        "Trouble",
        "fugitive",
        "copilot-chat",
      },
    },
  },
  {
    "mbbill/undotree",
    branch = "search",
    cmd = "UndotreeToggle",
    init = function()
      vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
      vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
    end,
  },
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
    end,
    lazy = true,
  },
  { "projekt0n/github-nvim-theme" },
}
