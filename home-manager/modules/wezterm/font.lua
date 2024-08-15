local M = {}

M.apply = function(c)
  local wezterm = require("wezterm")
  c.font = wezterm.font_with_fallback({
    "CommitMono Nerd Font Mono",
    "Hack Nerd Font Mono",
    "Iosevka Nerd Font Mono",
    "VictorMono Nerd Font",
    "JetBrainsMono Nerd Font",
  })
  c.adjust_window_size_when_changing_font_size = false
  c.window_frame = { font_size = 13.0 }
end
return M
