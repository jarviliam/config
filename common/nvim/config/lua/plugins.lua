local conf = require("conf")
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer...")
  vim.api.nvim_command("packadd packer.nvim")
end

-- initialize and configure packer
local packer = require("packer")

packer.init({
  enable = true, -- enable profiling via :PackerCompile profile=true
  threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  compile_path = install_path .. "/plugin/packer_compiled.lua",
  -- Have packer use a popup window
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use({ "nvim-lua/plenary.nvim" })
  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })
  use({ "lewis6991/impatient.nvim", as = "impatient" })
  --
  -----------------------------------------------------------------------------//
  -- LSP, Autocomplete and snippets {{{1
  -----------------------------------------------------------------------------//
  use({
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    wants = {
      "null-ls.nvim",
      "nvim-lsp-ts-utils",
    },
    config = function()
      require("core.lsp")
    end,
  })
  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    requires = {
      { "hrsh7th/cmp-nvim-lsp",     after = "nvim-cmp" },
      { "hrsh7th/cmp-path",         after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer",       after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua",     after = "nvim-cmp" },
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
    },
    config = get_config("compe"),
  })
  use({
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = 'require("modules.luasnip")',
    requires = "rafamadriz/friendly-snippets",
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
  })
  use({
    "jose-elias-alvarez/nvim-lsp-ts-utils",
  })
  use({
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
      require("nvim-navic").setup({ separator = " " })
    end,
  })
  use({
    "danymat/neogen",
    requires = "nvim-treesitter/nvim-treesitter",
    config = get_config("neogen"),
  })

  -----------------------------------------------------------------------------//
  -- Telescope {{{1
  -----------------------------------------------------------------------------//
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = get_config("telescope"),
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = get_config("trouble"),
  })

  use({
    "folke/which-key.nvim",
    event = "VimEnter",
    config = get_config("keys"),
  })
  -----------------------------------------------------------------------------//
  -- Treesitter {{{1
  -----------------------------------------------------------------------------//
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = get_config("treesitter"),
    requires = {
      {
        "nvim-treesitter/playground",
        cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
      },
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
    },
  })

  -----------------------------------------------------------------------------//
  -- Utils {{{1
  -----------------------------------------------------------------------------//
  use({ "numToStr/FTerm.nvim" })
  -----------------------------------------------------------------------------//
  -- Text Objects and Editing {{{1
  -----------------------------------------------------------------------------//
  use({
    "ggandor/lightspeed.nvim",
    as = "lightspeed",
    requires = { "tpope/vim-repeat", as = "repeat" },
  })
  use({
    "numToStr/Comment.nvim",
    config = get_config("comment"),
  })
  use("tpope/vim-surround")
  use({
    "windwp/nvim-autopairs",
    event = "InsertCharPre",
    config = get_config("autopairs"),
    after = "nvim-cmp",
  })
  use({ "numToStr/Navigator.nvim", config = get_config("navigate") })

  -----------------------------------------------------------------------------//
  -- Git {{{1
  -----------------------------------------------------------------------------//
  use({
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    module = "diffview",
    requires = "nvim-lua/plenary.nvim",
    config = get_config("diffview"),
  })
  use({
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim" },
    cmd = { "Neogit" },
    config = get_config("neogit"),
  })
  use({
    "pwntester/octo.nvim",
    config = get_config("octo"),
    requires = {
      'nvim-telescope/telescope.nvim'
    }
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = get_config("gitsigns"),
  })

  -----------------------------------------------------------------------------//
  -- Debugger {{{1
  -----------------------------------------------------------------------------//
  use({ "mfussenegger/nvim-dap" })
  use({
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  })
  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup({})
    end,
  })
  use({
    "mfussenegger/nvim-dap-python",
    requires = { "mfussenegger/nvim-dap" },
    config = require("modules.dap").setup(),
  })
  -----------------------------------------------------------------------------//
  -- Frontend {{{1
  -----------------------------------------------------------------------------//
  if conf.toggle_frontend then
    use({
      "windwp/nvim-ts-autotag",
      after = { "nvim-treesitter" },
    })
  end

  -----------------------------------------------------------------------------//
  -- General plugins {{{1
  -----------------------------------------------------------------------------//

  use({
    "nvim-lualine/lualine.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    event = "BufEnter",
    config = get_config("line"),
  })

  use({
    "j-hui/fidget.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "circle_halves",
        },
      })
    end,
  })

  use("tpope/vim-eunuch")

  use({
    "folke/todo-comments.nvim",
    as = "todo_comments",
    requires = "nvim-lua/plenary.nvim",
    config = get_config("todo"),
  })

  use({
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = "vim.g.undotree_WindowLayout = 2",
  })

  use({
    "mhinz/vim-startify",
    as = "startify",
    setup = function()
      vim.g.startify_fortune_use_unicode = 1
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = get_config("indent-lines"),
  })

  use({
    "rcarriga/nvim-notify",
    as = "notify",
    config = function()
      vim.notify = require("notify")
    end,
  })

  use({
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = get_config("scroll"),
  })
  use({ "folke/neodev.nvim" })

  -----------------------------------------------------------------------------//
  -- Themes {{{1
  -----------------------------------------------------------------------------//

  use({ "sainnhe/sonokai", config = get_config("themes.general") })
  use({ "sainnhe/edge", config = get_config("themes.general") })
  use({ "sainnhe/everforest", config = get_config("themes.general") })
  use({ "EdenEast/nightfox.nvim", config = get_config("themes.nightfox") })
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = get_config("themes.cat"),
  })
end)
