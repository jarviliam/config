return {
  {
    "goolord/alpha-nvim",
    enabled = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local icons = require("icons")
      dashboard.opts.layout[1].val = 7

      local header = [[
                      _   __                _
               / | / /__  ____ _   __(_)___ ___
              /  |/ / _ \/ __ \ | / / / __ `__ \
             / /|  /  __/ /_/ / |/ / / / / / / /
            /_/ |_/\___/\____/|___/_/_/ /_/ /_/

            ]]
      dashboard.section.header.val = vim.split(header, "\n")
      dashboard.section.header.opts.hl = "AlphaHeader"

      local function dashboard_button(sc, txt, keybind)
        local button = dashboard.button(sc, txt, keybind)
        button.opts.hl_shortcut = "AlphaShortcut"
        button.opts.hl = "AlphaButtons"
        -- Do not move the cursor, it creates a weird effect at the beginning.
        button.opts.cursor = 0
        return button
      end
      dashboard.section.buttons.val = {
        dashboard_button("f", icons.symbol_kinds.Folder .. "  Find file", "<cmd>FzfLua files<cr>"),
        dashboard_button("r", "  Recent files", "<cmd>FzfLua oldfiles<cr>"),
        dashboard_button("g", icons.misc.search .. "  Grep", "<cmd>FzfLua live_grep_glob<cr>"),
        dashboard_button("q", "  Quit", "<cmd>qa<cr>"),
        { type = "padding", val = 2 },
      }
      dashboard.section.buttons.opts.hl = "AlphaButtons"

      dashboard.section.footer.val = "It's not a bug, it's a feature."
      dashboard.section.footer.opts.hl = "AlphaFooter"

      return dashboard.opts
    end,
    config = function(_, opts)
      require("alpha").setup(opts)
    end,
  },
}
