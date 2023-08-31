local conf = require("conf")
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  { "jose-elias-alvarez/null-ls.nvim", enabled = false },
  {
    "ibhagwan/fzf-lua",
    dependencies = "kyazdani42/nvim-web-devicons",
    lazy = false,
    config = function()
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
  },
  {
    dir = "~/Coding/octo.nvim",
    config = get_config("octo"),
  },
  -- {
  --   "pwntester/octo.nvim",
  --   config = get_config("octo"),
  --   dependencies = {
  --     'nvim-telescope/telescope.nvim'
  --   }
  -- })
  {
    "karloskar/poetry-nvim",
    lazy = false,
    enabled = false,
  },
  -----------------------------------------------------------------------------//
  -- General plugins {{{1
  -----------------------------------------------------------------------------//

  {
    "nvim-lualine/lualine.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    event = "BufEnter",
    config = get_config("line"),
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
  },

  { "tpope/vim-eunuch", lazy = false },
  {
    "mbbill/undotree",
    branch = "search",
    cmd = "UndotreeToggle",
    keys = {
      { mode = "n", "<leader>u", ":UndotreeToggle<CR>", { silent = true } },
    },
    init = function()
      vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
      vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    init = function()
      vim.g.indent_blankline_char = "▎"
      vim.g.indent_blankline_char_blankline = "▎"
    end,
    opts = {
      filetype_exclude = {
        "lazy",
        "man",
        "gitmessengerpopup",
        "diagnosticpopup",
        "lspinfo",
        "help",
        "neo-tree",
        "NeogitStatus",
        "checkhealth",
        "TelescopePrompt",
        "TelescopeResults",
      },
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      use_treesitter_scope = true,
      space_char_blankline = " ",
      show_foldtext = false,
      strict_tabs = true,
      max_indent_increase = 1,
      show_current_context = false,
      show_current_context_start = false,
      context_highlight_list = { "IndentBlanklineContext" },
      viewport_buffer = 100,
    },
  },

  {
    "rcarriga/nvim-notify",
    init = function()
      local notify = require("notify")
      vim.notify = notify
    end,
    opts = {
      timeout = 2000,
      top_down = false,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    opts = {
      hide_cursor = false,
    },
  },

  {
    "olimorris/onedarkpro.nvim",
    lazy = conf.theme ~= "onedark",
    priority = 1000,
  },
  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest", lazy = conf.theme ~= "everforest" },
}
