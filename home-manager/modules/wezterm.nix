{ config, flakePath, pkgs, lib, ... }: {
  programs.wezterm = {
    enable = true;
    #colorSchemes = {
    #  onedarkpro = {
    #    background = "#000000";
    #    foreground = "#abb2bf";
    #    selection_bg = "#d55fde";
    #    selection_fg = "#abb2bf";
    #    ansi = [
    #      "#000000"
    #      "#ef596f"
    #      "#89ca78"
    #      "#e5c07b"
    #      "#61afef"
    #      "#d55fde"
    #      "#2bbac5"
    #      "#abb2bf"
    #    ];
    #    brights = [
    #      "#434852"
    #      "#f38897"
    #      "#a9d89d"
    #      "#edd4a6"
    #      "#8fc6f4"
    #      "#e089e7"
    #      "#4bced8"
    #      "#c8cdd5"
    #    ];
    #  };
    #};
  };
  xdg.configFile."wezterm/wezterm.lua".enable = false;
  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${flakePath}/home-manager/modules/wezterm";
    recursive = true;
  };
  # extraConfig = ''
  #    local function is_vi_process(pane)
  #      return pane:get_foreground_process_name():find("n?vim") ~= nil
  #    end
  #    -- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
  #    local function is_vim(pane)
  #      -- this is set by the plugin, and unset on ExitPre in Neovim
  #      return pane:get_user_vars().IS_NVIM == 'true'
  #    end
  #
  #        local direction_keys = {
  #          Left = "h",
  #          Down = "j",
  #          Up = "k",
  #          Right = "l",
  #          h = "Left",
  #          j = "Down",
  #          k = "Up",
  #          l = "Right",
  #        }
  #
  #        local function split_nav(resize_or_move, key)
  #          return {
  #            key = key,
  #            mods = resize_or_move == "resize" and "META" or "CTRL",
  #            action = wezterm.action_callback(function(win, pane)
  #              if is_vim(pane) then
  #                win:perform_action({
  #                  SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
  #                }, pane)
  #              else
  #                if resize_or_move == "resize" then
  #                  win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
  #                else
  #                  win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
  #                end
  #              end
  #            end),
  #          }
  #        end
  #  return {
  #    font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font" }),
  #    audible_bell = "Disabled",
  #    font_size = 11,
  #    front_end = "OpenGL",
  #    underline_thickness = "200%",
  #    underline_position = "-3pt",
  #    enable_wayland = false,
  #    pane_focus_follows_mouse = false,
  #    warn_about_missing_glyphs = false,
  #    show_update_window = false,
  #    check_for_updates = false,
  #    window_decorations = "RESIZE",
  #    window_padding = {
  #      left = 0,
  #      right = 0,
  #      top = 0,
  #      bottom = 0,
  #    },
  #    initial_cols = 110,
  #    initial_rows = 25,
  #    inactive_pane_hsb = {
  #      saturation = 0.7,
  #      brightness = 0.6,
  #    },
  #    enable_scroll_bar = false,
  #    tab_bar_at_bottom = true,
  #    use_fancy_tab_bar = false,
  #    show_new_tab_button_in_tab_bar = false,
  #    window_background_opacity = 0.6,
  #    macos_window_background_blur = 20,
  #    tab_max_width = 50,
  #    hide_tab_bar_if_only_one_tab = true,
  #    disable_default_key_bindings = false,
  #    color_scheme = 'catppuccin-frappe',
  #    keys = {
  #          split_nav("move", "h"),
  #          split_nav("move", "j"),
  #          split_nav("move", "k"),
  #          split_nav("move", "l"),
  #          split_nav("resize", "h"),
  #          split_nav("resize", "j"),
  #          split_nav("resize", "k"),
  #          split_nav("resize", "l"),
  #          {
  #            mods = "ALT",
  #            key = [[\]],
  #            action = wezterm.action({
  #              SplitHorizontal = { domain = "CurrentPaneDomain" },
  #            }),
  #          },
  #          {
  #            mods = "ALT|SHIFT",
  #            key = [[|]],
  #            action = wezterm.action.SplitPane({
  #              top_level = true,
  #              direction = "Right",
  #              size = { Percent = 50 },
  #            }),
  #          },
  #          {
  #            mods = "ALT",
  #            key = [[-]],
  #            action = wezterm.action({
  #              SplitVertical = { domain = "CurrentPaneDomain" },
  #            }),
  #          },
  #          {
  #            mods = "ALT|SHIFT",
  #            key = [[_]],
  #            action = wezterm.action.SplitPane({
  #              top_level = true,
  #              direction = "Down",
  #              size = { Percent = 50 },
  #            }),
  #          },
  #          {
  #            key = "n",
  #            mods = "ALT",
  #            action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  #          },
  #          {
  #            key = "Q",
  #            mods = "ALT",
  #            action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
  #          },
  #          { key = "q",   mods = "ALT",        action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  #          { key = "z",   mods = "ALT",        action = wezterm.action.TogglePaneZoomState },
  #          { key = "F11", mods = "",           action = wezterm.action.ToggleFullScreen },
  #          { key = "[",   mods = "ALT",        action = wezterm.action({ ActivateTabRelative = -1 }) },
  #          { key = "]",   mods = "ALT",        action = wezterm.action({ ActivateTabRelative = 1 }) },
  #          { key = "{",   mods = "SHIFT|ALT",  action = wezterm.action.MoveTabRelative( -1) },
  #          { key = "}",   mods = "SHIFT|ALT",  action = wezterm.action.MoveTabRelative(1) },
  #          { key = "y",   mods = "ALT",        action = wezterm.action.ActivateCopyMode },
  #          { key = "c",   mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
  #          { key = "v",   mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
  #          { key = "=",   mods = "CTRL",       action = wezterm.action.IncreaseFontSize },
  #          { key = "-",   mods = "CTRL",       action = wezterm.action.DecreaseFontSize },
  #          { key = "1",   mods = "ALT",        action = wezterm.action({ ActivateTab = 0 }) },
  #          { key = "2",   mods = "ALT",        action = wezterm.action({ ActivateTab = 1 }) },
  #          { key = "3",   mods = "ALT",        action = wezterm.action({ ActivateTab = 2 }) },
  #          { key = "4",   mods = "ALT",        action = wezterm.action({ ActivateTab = 3 }) },
  #          { key = "5",   mods = "ALT",        action = wezterm.action({ ActivateTab = 4 }) },
  #          { key = "6",   mods = "ALT",        action = wezterm.action({ ActivateTab = 5 }) },
  #          { key = "7",   mods = "ALT",        action = wezterm.action({ ActivateTab = 6 }) },
  #          { key = "8",   mods = "ALT",        action = wezterm.action({ ActivateTab = 7 }) },
  #          { key = "9",   mods = "ALT",        action = wezterm.action({ ActivateTab = 8 }) },
  #        },
  #    hyperlink_rules = {
  #      {
  #        regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
  #        format = "$0",
  #      },
  #      {
  #        regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
  #        format = "$0",
  #      },
  #      {
  #        regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
  #        format = "mailto:$0",
  #      },
  #      {
  #        regex = [[\bfile://\S*\b]],
  #        format = "$0",
  #      },
  #      {
  #        regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
  #        format = "$0",
  #      },
  #      {
  #        regex = [[\b[tT](\d+)\b]],
  #        format = "https://example.com/tasks/?t=$1",
  #      },
  #    },
  #  }
  #'';
}
