--@type wezterm
local wezterm = require("wezterm")
local c = wezterm.config_builder()

require("keys").apply(c)

c.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
})
c.audible_bell = "Disabled"
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- c.default_cursor_style = "BlinkingBar"
c.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 0.8,
}
c.color_scheme = "catppuccin-frappe"
c.window_decorations = "RESIZE"
c.window_background_opacity = 0.8
c.macos_window_background_blur = 20
c.hide_tab_bar_if_only_one_tab = true
c.clean_exit_codes = { 130 }
c.adjust_window_size_when_changing_font_size = false
c.command_palette_font_size = 13.0
c.window_frame = { font_size = 13.0 }

c.tab_bar_at_bottom = true
c.use_fancy_tab_bar = false
c.tab_max_width = 32

local dividers = {
  slant_right = {
    left = utf8.char(0xe0be),
    right = utf8.char(0xe0bc),
  },
  slant_left = {
    left = utf8.char(0xe0ba),
    right = utf8.char(0xe0b8),
  },
  arrows = {
    left = utf8.char(0xe0b2),
    right = utf8.char(0xe0b0),
  },
  rounded = {
    left = utf8.char(0xe0b6),
    right = utf8.char(0xe0b4),
  },
}

local scheme = wezterm.get_builtin_color_schemes()["Catppuccin Frappe"]
wezterm.on(
  "format-tab-title",
  function(tab, tabs, _panes, conf, _hover, _max_width)
    local process_name = string.gsub(
      tab.active_pane.foreground_process_name,
      "(.*[/\\])(.*)",
      "%2"
    )

    local active_tab_index = 0
    for _, t in ipairs(tabs) do
      if t.is_active == true then
        active_tab_index = t.tab_index
      end
    end

    -- TODO: make colors configurable
    local rainbow = {
      scheme.ansi[2],
      scheme.indexed[16],
      scheme.ansi[4],
      scheme.ansi[3],
      scheme.ansi[5],
      scheme.ansi[6],
    }

    local i = tab.tab_index % 6
    local active_bg = rainbow[i + 1]
    local active_fg = scheme.background
    local inactive_bg = scheme.tab_bar.inactive_tab.bg_color
    local inactive_fg = scheme.tab_bar.inactive_tab.fg_color
    local new_tab_bg = scheme.tab_bar.new_tab.bg_color

    local s_bg, s_fg, e_bg, e_fg

    -- the last tab
    if tab.tab_index == #tabs - 1 then
      if tab.is_active then
        s_bg = active_bg
        s_fg = active_fg
        e_bg = new_tab_bg
        e_fg = active_bg
      else
        s_bg = inactive_bg
        s_fg = inactive_fg
        e_bg = new_tab_bg
        e_fg = inactive_bg
      end
    elseif tab.tab_index == active_tab_index - 1 then
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = rainbow[(i + 1) % 6 + 1]
      e_fg = inactive_bg
    elseif tab.is_active then
      s_bg = active_bg
      s_fg = active_fg
      e_bg = inactive_bg
      e_fg = active_bg
    else
      s_bg = inactive_bg
      s_fg = inactive_fg
      e_bg = inactive_bg
      e_fg = inactive_bg
    end

    return {
      { Background = { Color = s_bg } },
      { Foreground = { Color = s_fg } },
      { Text = string.format(" %s  ", tab.tab_index + 1) },
      { Text = process_name },
      { Text = " " },
      { Background = { Color = e_bg } },
      { Foreground = { Color = e_fg } },
      { Text = dividers.slant_right.right },
    }
  end
)

return c
