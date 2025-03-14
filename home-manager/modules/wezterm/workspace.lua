local wezterm = require("wezterm")
local M = {}
M.apply = function(c)
  local scheme = require("colors").color_scheme
  local workspace_switcher = wezterm.plugin.require(
    "https://github.com/MLFlexer/smart_workspace_switcher.wezterm"
  )
  table.insert(c.keys, {
    key = "s",
    mods = "SHIFT|SUPER",
    action = workspace_switcher.switch_workspace({
      extra_args = " | rg -FxNf ~/.projects",
    }),
  })
  workspace_switcher.workspace_formatter = function(label)
    return wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Text = "󱂬: " .. label },
    })
  end
  wezterm.on(
    "smart_workspace_switcher.workspace_switcher.selected",
    function(window, path, label)
      local base_path = string.gsub(path, "(.*[/\\])(.*)", "%2")
      window:set_right_status(wezterm.format({
        { Foreground = { Color = scheme.ansi[5] } },
        { Text = base_path .. "  " },
      }))
    end
  )

  wezterm.on(
    "smart_workspace_switcher.workspace_switcher.created",
    function(window, path, label)
      local base_path = string.gsub(path, "(.*[/\\])(.*)", "%2")
      window:set_right_status(wezterm.format({
        { Foreground = { Color = scheme.ansi[5] } },
        { Text = base_path .. "  " },
      }))
    end
  )

  wezterm.on("update-right-status", function(window, pane)
    window:set_right_status(window:active_workspace())
  end)
end

return M
