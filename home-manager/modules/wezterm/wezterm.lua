local wezterm = require("wezterm") --[[@as Wezterm]]
local config = wezterm.config_builder()

require("colors").apply(config)
require("tabs").setup(config)
require("keys").setup(config)
require("workspace").apply(config)
require("font").apply(config)
require("links").setup(config)

config.audible_bell = "Disabled"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.underline_thickness = 2
config.cursor_thickness = 4
config.underline_position = -6

config.bold_brightens_ansi_colors = true

config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.scrollback_lines = 10000

config.window_decorations = "RESIZE"
config.window_background_opacity = 1
config.macos_window_background_blur = 0
config.native_macos_fullscreen_mode = false
config.clean_exit_codes = { 130 }
config.command_palette_font_size = 13.0

config.max_fps = 120

return config
