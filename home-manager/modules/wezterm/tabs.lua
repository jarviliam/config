local wezterm = require("wezterm")
local M = {}

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

---@param tab MuxTabObj
function M.get_current_working_folder_name(tab)
  local cwd_uri = tab.active_pane.current_working_dir

  if not cwd_uri then
    return ""
  end

  if type(cwd_uri) == "userdata" then
    cwd_uri = cwd_uri.file_path
  end

  cwd_uri = cwd_uri:sub(8)

  local slash = cwd_uri:find("/")
  if not slash then
    return ""
  end

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

function M.get_process(tab, scheme)
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
      { Foreground = { Color = "#f2d5cf" } },
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
      { Foreground = { Color = "#f2d5cf" } },
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
    { Text = string.format("[%s]", process_name) },
  })
end

function M.setup(config)
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 32
  config.hide_tab_bar_if_only_one_tab = false
  config.unzoom_on_switch_pane = true

  local scheme = require("colors").color_scheme

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
        scheme.ansi[7],
        scheme.ansi[4],
        scheme.ansi[3],
        scheme.ansi[5],
        scheme.ansi[6],
      }

      local i = tab.tab_index % 6
      local active_bg = rainbow[i + 1]
      local active_fg = scheme.selection_bg
      local inactive_bg = scheme.background
      local inactive_fg = scheme.foreground
      local new_tab_bg = scheme.background

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
        { Text = M.get_process(tab, scheme) },
        { Text = " " },
        { Text = M.get_current_working_folder_name(tab) },
        { Background = { Color = e_bg } },
        { Foreground = { Color = e_fg } },
        { Text = dividers.slant_right.right },
      }
    end
  )
end

return M
