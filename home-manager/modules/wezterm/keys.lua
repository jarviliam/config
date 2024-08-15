--@type wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

-- {
--   key = "9",
--   mods = "ALT",
--   action = wezterm.action({ ActivateTab = 8 }),
-- },
local keys = {}
local function map(key, mods, action)
  if type(mods) == "string" then
    table.insert(keys, { key = key, mods = mods, action = action })
  elseif type(mods) == "table" then
    for _, m in pairs(mods) do
      table.insert(keys, { key = key, mods = m, action = action })
    end
  end
end

local openUrl = act.QuickSelectArgs({
  label = "open url",
  patterns = { "https?://\\S+" },
  action = wezterm.action_callback(function(window, pane)
    local url = window:get_selection_text_for_pane(pane)
    wezterm.open_with(url)
  end),
})

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({
          SendKey = {
            key = key,
            mods = resize_or_move == "resize" and "META" or "CTRL",
          },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action(
            { AdjustPaneSize = { direction_keys[key], 3 } },
            pane
          )
        else
          win:perform_action(
            { ActivatePaneDirection = direction_keys[key] },
            pane
          )
        end
      end
    end),
  }
end

local M = {}
M.apply = function(c)
  c.leader = {
    key = " ",
    mods = "CTRL",
    timeout_milliseconds = math.maxinteger,
  }
  map([[\]], "LEADER", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
  map(
    [[|]],
    "LEADER",
    act.SplitPane({
      top_level = true,
      direction = "Right",
      size = { Percent = 50 },
    })
  )
  map("-", "ALT", act.SplitVertical({ domain = "CurrentPaneDomain" }))
  map(
    "_",
    "LEADER",
    act.SplitPane({
      top_level = true,
      direction = "Down",
      size = { Percent = 50 },
    })
  )
  for i = 1, 9 do
    map(tostring(i), { "LEADER", "SUPER" }, act.ActivateTab(i - 1))
  end
  map("c", "LEADER", act.SpawnTab("CurrentPaneDomain"))
  map("x", { "LEADER", "SHIFT|CTRL" }, act.CloseCurrentPane({ confirm = true }))
  map("t", { "SHIFT|CTRL", "SUPER" }, act.SpawnTab("CurrentPaneDomain"))
  map("w", { "SHIFT|CTRL", "SUPER" }, act.CloseCurrentTab({ confirm = true }))
  map("n", { "SHIFT|CTRL", "SUPER" }, act.SpawnWindow)
  map("z", { "LEADER", "SHIFT|CTRL" }, act.TogglePaneZoomState)
  map("v", "LEADER", act.ActivateCopyMode)
  map("c", { "SHIFT|CTRL", "SUPER" }, act.CopyTo("Clipboard"))
  map("v", { "SHIFT|CTRL", "SUPER" }, act.PasteFrom("Clipboard"))
  map(
    "f",
    { "SHIFT|CTRL", "SUPER" },
    act.Search({ CaseInSensitiveString = "" })
  )
  map("e", { "LEADER", "SUPER" }, act.RotatePanes("Clockwise"))
  map(" ", "LEADER", act.QuickSelect)
  map("o", { "LEADER", "SUPER" }, openUrl)
  map("p", { "LEADER", "SUPER" }, act.PaneSelect({ alphabet = "asdfghjkl;" }))
  map("R", { "LEADER", "SUPER" }, act.ReloadConfiguration)
  map("u", "SHIFT|CTRL", act.CharSelect)
  map("p", { "SHIFT|CTRL", "SHIFT|SUPER" }, act.ActivateCommandPalette)

  map("Enter", "ALT", act.ToggleFullScreen)
  map("-", { "CTRL", "SUPER" }, act.DecreaseFontSize)
  map("=", { "CTRL", "SUPER" }, act.IncreaseFontSize)
  map("0", { "CTRL", "SUPER" }, act.ResetFontSize)

  map("f", "LEADER", act.EmitEvent("switch-font"))
  map("l", "SHIFT|CTRL", act.ShowDebugOverlay)
  map(
    "F12",
    "",
    wezterm.action_callback(function(_, pane)
      local tab = pane:tab()
      local panes = tab:panes_with_info()
      if #panes == 1 then
        pane:split({ direction = "Right", size = 0.4 })
      elseif not panes[1].is_zoomed then
        panes[1].pane:activate()
        tab:set_zoomed(true)
      elseif panes[1].is_zoomed then
        tab:set_zoomed(false)
        panes[2].pane:activate()
      end
    end)
  )
  c.keys = {
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
    table.unpack(keys),
  }
  c.disable_default_key_bindings = true
end
return M
