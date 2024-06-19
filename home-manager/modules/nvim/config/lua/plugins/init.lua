local conf = require("conf")

return {
  "nvim-lua/plenary.nvim",
  "b0o/SchemaStore.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "mbbill/undotree",
    branch = "search",
    cmd = "UndotreeToggle",
    keys = { { mode = "n", "<leader>u", ":UndotreeToggle<CR>", { silent = true } } },
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
    "garymjr/nvim-snippets",
    enabled = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      friendly_snippets = true,
      create_autocmd = true,
    },
  },
  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai", dev = true },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest", lazy = conf.theme ~= "everforest" },
  { "sainnhe/gruvbox-material", lazy = false },
  { "projekt0n/github-nvim-theme" },
}
