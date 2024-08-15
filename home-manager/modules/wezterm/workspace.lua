local M = {}
M.apply = function(c)
  local wezterm = require("wezterm")
  local workspace_switcher = wezterm.plugin.require(
    "https://github.com/MLFlexer/smart_workspace_switcher.wezterm"
  )
  table.insert(c.keys, {
    key = "s",
    mods = "ALT",
    action = workspace_switcher.switch_workspace(" | rg -FxNf ~/.projects"),
  })
  workspace_switcher.set_workspace_formatter(function(label)
    return wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Text = "󱂬: " .. label },
    })
  end)
end

return M
