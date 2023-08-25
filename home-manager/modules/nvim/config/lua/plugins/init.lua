local conf = require("conf")
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = {default = true},
  },
  --
  -----------------------------------------------------------------------------//
  -- LSP, Autocomplete and snippets {{{1
  -----------------------------------------------------------------------------//
  {
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
      require("modules.lsp.null").setup()
      require("lsp")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = 'require("modules.luasnip")',
    dependencies ={ "rafamadriz/friendly-snippets"},
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
  },
  {
    "danymat/neogen",
    config = get_config("neogen"),
  },

  -----------------------------------------------------------------------------//
  -- Telescope {{{1
  -----------------------------------------------------------------------------//
  {
    "ibhagwan/fzf-lua",
    dependencies = "kyazdani42/nvim-web-devicons",
    lazy=false,
    config = function()
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = get_config("trouble"),
  },

  -----------------------------------------------------------------------------//
  -- Text Objects and Editing {{{1
  -----------------------------------------------------------------------------//
  {
    "echasnovski/mini.comment",
    event = "BufReadPre",
    opts = {},
    config = function()
      require("mini.comment").setup({})
    end,
  },
  "tpope/vim-surround, lazy=false",
  { "numToStr/Navigator.nvim",lazy=false, config = get_config("navigate") },

  -----------------------------------------------------------------------------//
  -- Git {{{1
  -----------------------------------------------------------------------------//
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
    config = function()
      require("poetry-nvim").setup()
    end,
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

{"tpope/vim-eunuch",lazy=false},
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = "vim.g.undotree_WindowLayout = 2",
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
  event = "BufReadPre",
    opts = {
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = "",
      },
    },
    config = function(_, opts)
      require("mini.jump").setup(opts)
    end,
  },
  {
    "echasnovski/mini.bufremove",
    branch = "stable",
    keys = {
      {"<leader>bd",'require("mini.bufremove").delete(0, false)',desc="Delete Buffer"},
      {"<leader>bD",'require("mini.bufremove").delete(0, true)',desc="Delete Buffer (Force)"}
    },
    config = function()
      require("mini.bufremove").setup()
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
      filetype_exclude= {
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
    buftype_exclude                = { "terminal" },
    show_trailing_blankline_indent = false,
    use_treesitter_scope           = true,
    space_char_blankline           = " ",
    show_foldtext                  = false,
    strict_tabs                    = true,
    max_indent_increase            = 1,
    show_current_context           = false,
    show_current_context_start     = false,
    context_highlight_list         = { "IndentBlanklineContext" },
    viewport_buffer                = 100,
    }
  },

  {
    "rcarriga/nvim-notify",
    init = function()
      local notify = require("notify")
      vim.notify = notify
    end,
  },

  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = get_config("scroll"),
  },

  { "sainnhe/sonokai",lazy = conf.theme ~= "sonokai" },
  { "sainnhe/edge", lazy=conf.theme ~= "edge"},
  { "sainnhe/everforest", lazy=conf.theme ~="everforest"},
}
