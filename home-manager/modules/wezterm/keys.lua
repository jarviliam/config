local wezterm = require("wezterm") --[[@as Wezterm]]

local act = wezterm.action
local M = {}

function M.is_vim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
    or pane:get_foreground_process_name():find("nvim")
end

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

M.smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(
      act.SplitVertical({ domain = "CurrentPaneDomain" }),
      pane
    )
  else
    window:perform_action(
      act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
      pane
    )
  end
end)

function M.split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if M.is_vim(pane) then
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

function M.setup(config)
  config.disable_default_key_bindings = true
  config.leader = {
    key = " ",
    mods = "CTRL",
    timeout_milliseconds = math.maxinteger,
  }
  table.insert(
    keys,
    { key = "k", mods = "SHIFT|SUPER", action = act.ScrollByPage(-0.5) }
  )
  table.insert(
    keys,
    { key = "j", mods = "SHIFT|SUPER", action = act.ScrollByPage(0.5) }
  )
  map("Enter", "SHIFT|SUPER", M.smart_split)
  map("w", "SHIFT|SUPER", act({ ActivateTabRelative = 1 }))
  map("b", "SHIFT|SUPER", act({ ActivateTabRelative = -1 }))

  map(
    "|",
    "LEADER",
    act.SplitHorizontal({
      domain = "CurrentPaneDomain",
    })
  )
  map("_", "ALT", act.SplitVertical({ domain = "CurrentPaneDomain" }))

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
    map(tostring(i), { "LEADER" }, act.ActivateTab(i - 1))
  end

  map("t", { "SHIFT|SUPER" }, act.SpawnTab("CurrentPaneDomain"))
  map("z", { "LEADER", "SHIFT|CTRL" }, act.TogglePaneZoomState)
  map("v", "LEADER", act.ActivateCopyMode)

  map("c", { "SHIFT|SUPER", "SUPER" }, act.CopyTo("Clipboard"))
  map("v", { "SHIFT|SUPER" }, act.PasteFrom("Clipboard"))

  map("f", { "SHIFT|SUPER" }, act.Search({ CaseInSensitiveString = "" }))
  map("r", { "LEADER", "SUPER" }, act.RotatePanes("Clockwise"))

  map(" ", "SHIFT|SUPER", act.QuickSelect)
  map("o", { "SHIFT|SUPER" }, openUrl)
  map("s", { "SHIFT|SUPER" }, act.PaneSelect({ alphabet = "asdfghjkl;" }))

  map("p", "SHIFT|SUPER", act.ActivateCommandPalette)
  map("d", "SHIFT|SUPER", act.ShowDebugOverlay)

  map(
    "F11",
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
  config.keys = {
    M.split_nav("move", "h"),
    M.split_nav("move", "j"),
    M.split_nav("move", "k"),
    M.split_nav("move", "l"),
    M.split_nav("resize", "h"),
    M.split_nav("resize", "j"),
    M.split_nav("resize", "k"),
    M.split_nav("resize", "l"),
    table.unpack(keys),
  }
end

return M
