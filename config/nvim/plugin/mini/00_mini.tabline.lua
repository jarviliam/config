Config.now(function()
  require("mini.tabline").setup({
    -- Whether to show file icons (requires 'mini.icons')
    show_icons = true,
    -- Function which formats the tab label
    -- By default surrounds with space and possibly prepends with icon
    format = nil,
    -- Where to show tabpage section in case of multiple vim tabpages.
    -- One of 'left', 'right', 'none'.
    tabpage_section = "left",
  })
end)
