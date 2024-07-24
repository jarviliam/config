local conf = require("conf")

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "mbbill/undotree",
    branch = "search",
    cmd = "UndotreeToggle",
    keys = { { mode = "n", "<leader>U", ":UndotreeToggle<CR>", { silent = true } } },
    init = function()
      vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
      vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
    end,
  },
  {
    "creativenull/efmls-configs-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
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
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    dev = true,
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true,
  },
  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest", lazy = conf.theme ~= "everforest" },
  { "sainnhe/gruvbox-material", lazy = false },
  { "projekt0n/github-nvim-theme" },
}
