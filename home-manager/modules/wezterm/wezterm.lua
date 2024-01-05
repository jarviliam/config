--@type wezterm
local wezterm = require("wezterm")
local c = wezterm.config_builder()


require("keys").apply(c)

c.font = wezterm.font_with_fallback({
  "Hack Nerd Font Mono",
  "Berkeley Mono Trial",
  "Iosevka Nerd Font Mono",
  "VictorMono Nerd Font",
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
c.native_macos_fullscreen_mode = false
c.hide_tab_bar_if_only_one_tab = true
c.clean_exit_codes = { 130 }
c.adjust_window_size_when_changing_font_size = false
c.command_palette_font_size = 13.0
c.window_frame = { font_size = 13.0 }

c.tab_bar_at_bottom = true
c.use_fancy_tab_bar = false
c.tab_max_width = 32

c.hyperlink_rules = {
  { regex = [["([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)"]], format = "https://www.github.com/$1/$3" },
  {
    regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
    format = "$0",
  },
  {
    regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
    format = "$0",
  },
  {
    regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
    format = "mailto:$0",
  },
  {
    regex = [[\bfile://\S*\b]],
    format = "$0",
  },
  {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = "$0",
  },
}

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

local function get_current_working_folder_name(tab)
  local cwd_uri = tab.active_pane.current_working_dir

  if cwd_uri == nil or cwd_uri == "" then
    return ""
  end
  cwd_uri = cwd_uri:sub(8)

  local slash = cwd_uri:find("/")
  local cwd = cwd_uri:sub(slash)
  if cwd:sub(-1) == "/" then
    cwd = cwd:sub(1, -2)
  end

  local HOME_DIR = os.getenv("HOME")
  if cwd == HOME_DIR then
    return "  ~"
  end

  return string.format("  %s", string.match(cwd, "[^/]+$"))
end

local scheme = wezterm.get_builtin_color_schemes()["Catppuccin Frappe"]

local function get_process(tab)
  local process_icons = {
    ["docker"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["docker-compose"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["nvim"] = {
      { Foreground = { Color = scheme.ansi[3] } },
      { Text = wezterm.nerdfonts.custom_vim },
    },
    ["bob"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.custom_vim },
    },
    ["vim"] = {
      { Foreground = { Color = scheme.ansi[3] } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ["node"] = {
      { Foreground = { Color = scheme.ansi[3] } },
      { Text = wezterm.nerdfonts.mdi_hexagon },
    },
    ["zsh"] = {
      { Foreground = { Color = "#838ba7" } },
      { Text = wezterm.nerdfonts.dev_terminal },
    },
    ["bash"] = {
      { Foreground = { Color = "#838ba7" } },
      { Text = wezterm.nerdfonts.cod_terminal_bash },
    },
    ["htop"] = {
      { Foreground = { Color = scheme.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["btop"] = {
      { Foreground = { Color = "#f2d5cf" } },
      { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["cargo"] = {
      { Foreground = { Color = scheme.indexed[16] } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = "#85c1dc" } },
      { Text = wezterm.nerdfonts.mdi_language_go },
    },
    ["lazydocker"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["git"] = {
      { Foreground = { Color = scheme.indexed[16] } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lazygit"] = {
      { Foreground = { Color = "#ca9ee6" } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lua"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.seti_lua },
    },
    ["wget"] = {
      { Foreground = { Color = scheme.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_arrow_down_box },
    },
    ["curl"] = {
      { Foreground = { Color = scheme.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_flattr },
    },
    ["gh"] = {
      { Foreground = { Color = "#ca9ee6" } },
      { Text = wezterm.nerdfonts.dev_github_badge },
    },
    ["flatpak"] = {
      { Foreground = { Color = scheme.ansi[5] } },
      { Text = wezterm.nerdfonts.mdi_package_variant },
    },
  }

  local process_name =
    string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  if process_name == "" then
    process_name = "zsh"
  end

  return wezterm.format(process_icons[process_name] or {
    { Foreground = { Color = "#99d1db" } },
    { Text = string.format("[%s]", process_name) },
  })
end

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
      { Text = get_process(tab) },
      { Text = " " },
      { Text = get_current_working_folder_name(tab) },
      { Background = { Color = e_bg } },
      { Foreground = { Color = e_fg } },
      { Text = dividers.slant_right.right },
    }
  end
)

return c
