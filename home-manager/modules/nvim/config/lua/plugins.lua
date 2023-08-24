local conf = require("conf")
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
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
    "ray-x/lsp_signature.nvim", config = function()
    require "lsp_signature".setup({
      handler_opts = { border = "rounded" },
      hint_prefix = "",
      fixpos = true,
      padding = " ",
    })
  end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
       "hrsh7th/cmp-nvim-lsp",
       "hrsh7th/cmp-path",
       "hrsh7th/cmp-buffer",
       "hrsh7th/cmp-nvim-lua",
       "hrsh7th/cmp-nvim-lua",
       "saadparwaiz1/cmp_luasnip",
       "petertriho/cmp-git",
    },
    config = get_config("compe"),
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
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " " })
    end,
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = get_config("neogen"),
  },

  -----------------------------------------------------------------------------//
  -- Telescope {{{1
  -----------------------------------------------------------------------------//
  {
    "ibhagwan/fzf-lua",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },
  {
    -- "~/Coding/telescope.nvim",
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
    },
    config = get_config("telescope"),
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  },
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = get_config("trouble"),
  },

  {
    "folke/which-key.nvim",
    lazy=true,
    config = get_config("keys"),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = get_config("treesitter"),
    dependencies = {
      { "nvim-treesitter/playground", cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
      },
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
    },    event = "User FileOpened",
  },
  -----------------------------------------------------------------------------//
  -- Text Objects and Editing {{{1
  -----------------------------------------------------------------------------//
  {
    "echasnovski/mini.comment",
    branch = "stable",
    config = function()
      require("mini.comment").setup()
    end,
  },
  "tpope/vim-surround",
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = get_config("autopairs"),
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },
  { "numToStr/Navigator.nvim", config = get_config("navigate") },

  -----------------------------------------------------------------------------//
  -- Git {{{1
  -----------------------------------------------------------------------------//
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    dependencies = {"nvim-lua/plenary.nvim"},
    config = get_config("diffview"),
  },
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Neogit" },
    config = get_config("neogit"),
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
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = get_config("gitsigns"),
  },

  { "mfussenegger/nvim-dap",lazy=true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python"
    },
    config = require("modules.dap").setup() 
  },
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

{"tpope/vim-eunuch"},

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = "vim.g.undotree_WindowLayout = 2",
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
    config = function()
      require("mini.jump").setup()
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
    "mhinz/vim-startify",
    as = "startify",
    setup = function()
      vim.g.startify_fortune_use_unicode = 1
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = get_config("indent-lines"),
  },

  {
    "rcarriga/nvim-notify",
    as = "notify",
    config = function()
      vim.notify = require("notify")
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
  { "EdenEast/nightfox.nvim", config = get_config("themes.nightfox") },
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = get_config("themes.cat"),
  }
}
