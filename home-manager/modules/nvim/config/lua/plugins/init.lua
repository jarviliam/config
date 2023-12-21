local conf = require("conf")
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

return {
  "nvim-lua/plenary.nvim",
  "b0o/SchemaStore.nvim",
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
      require("fzf-lua").setup({
        "fzf-native",
      })
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
}
