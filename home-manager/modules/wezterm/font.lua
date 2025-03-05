local M = {}

M.apply = function(config)
  local wezterm = require("wezterm")
  config.font = wezterm.font_with_fallback({
    "CommitMono Nerd Font Mono",
    "Hack Nerd Font Mono",
  })
  config.font_rules = {
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({
        family = "Hack Nerd Font Mono",
        weight = "Bold",
        style = "Italic",
      }),
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font({
        family = "Hack Nerd Font Mono",
        weight = "DemiBold",
        style = "Italic",
      }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font({ family = "Hack Nerd Font Mono", style = "Italic" }),
    },
  }
  config.adjust_window_size_when_changing_font_size = false
  config.window_frame = { font_size = 13.0 }
  config.font_size = 13.0
end
return M
