return {
  "freddiehaddad/feline.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = { "UIEnter" },
  config = function()
    require("feline").setup()
    -- require("feline").statuscolumn.setup()
  end,
}
