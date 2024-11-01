local conf = require("conf")

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "m4xshen/hardtime.nvim",
    command = "Hardtime",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", { "nvim-lua/plenary.nvim", lazy = true } },
    opts = {
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
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },
  {
    "garymjr/nvim-snippets",
    enabled = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      friendly_snippets = true,
      create_autocmd = true,
    },
  },
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    lazy = false,
    config = function()
      local leap = require("leap")
      leap.opts.special_keys.next_target = "<enter>"
      leap.opts.special_keys.prev_target = "<backspace>"

      leap.create_default_mappings()
    end,
  },
  { "tpope/vim-abolish", command = "S" },
  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest" },
  { "sainnhe/gruvbox-material", lazy = false },
  { "projekt0n/github-nvim-theme" },
}
