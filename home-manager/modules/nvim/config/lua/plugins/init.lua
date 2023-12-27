local conf = require("conf")
return {
  "nvim-lua/plenary.nvim",
  "b0o/SchemaStore.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = "kyazdani42/nvim-web-devicons",
    lazy = false,
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        "fzf-native",
        fzf_colors = {
          bg = { "bg", "Normal" },
          gutter = { "bg", "Normal" },
          info = { "fg", "Conditional" },
          scrollbar = { "bg", "Normal" },
          separator = { "fg", "Comment" },
        },
        fzf_opts = {
          ["--info"] = "default",
          ["--layout"] = "reverse-list",
        },
        helptags = {
          actions = {
            -- Open help pages in a vertical split.
            ["default"] = actions.help_vert,
          },
        },
        lsp = {
          code_actions = {
            previewer = "codeaction_native",
            preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
          },
        },
      }
    end,
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
    "creativenull/efmls-configs-nvim",
    version = "v1.4.0",
    dependencies = { "neovim/nvim-lspconfig" },
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
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
    cmd = { "Hardtime" },
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = conf.theme ~= "onedark",
    priority = 1000,
  },

  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest", lazy = conf.theme ~= "everforest" },
  { "sainnhe/gruvbox-material", lazy = false },
}
