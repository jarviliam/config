return {
  "freddiehaddad/feline.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = { "UIEnter" },
  config = function()
    local ctp_feline = require("catppuccin.groups.integrations.feline")
    ctp_feline.setup({})
    require("feline").setup({
      components = ctp_feline.get(),
    })
    -- require("feline").statuscolumn.setup()
  end,
}
