{ config, pkgs, lib, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
                                          wezterm.GLOBAL.is_dark = true
                                          local Theme = {}

                                          local catppuccin = {
                                            light = {
                                              rosewater = "#dc8a78",
                                              flamingo = "#DD7878",
                                              pink = "#ea76cb",
                                              mauve = "#8839EF",
                                              red = "#D20F39",
                                              maroon = "#E64553",
                                              peach = "#FE640B",
                                              yellow = "#df8e1d",
                                              green = "#40A02B",
                                              teal = "#179299",
                                              sky = "#04A5E5",
                                              sapphire = "#209FB5",
                                              blue = "#1e66f5",
                                              lavender = "#7287FD",
                                              text = "#4C4F69",
                                              subtext1 = "#5C5F77",
                                              subtext0 = "#6C6F85",
                                              overlay2 = "#7C7F93",
                                              overlay1 = "#8C8FA1",
                                              overlay0 = "#9CA0B0",
                                              surface2 = "#ACB0BE",
                                              surface1 = "#BCC0CC",
                                              surface0 = "#CCD0DA",
                                              base = "#EFF1F5",
                                              mantle = "#E6E9EF",
                                              crust = "#DCE0E8",
                                            },
                                            dark = {
                                              rosewater = "#F5E0DC",
                                              flamingo = "#F2CDCD",
                                              pink = "#F5C2E7",
                                              mauve = "#CBA6F7",
                                              red = "#F38BA8",
                                              maroon = "#EBA0AC",
                                              peach = "#FAB387",
                                              yellow = "#F9E2AF",
                                              green = "#A6E3A1",
                                              teal = "#94E2D5",
                                              sky = "#89DCEB",
                                              sapphire = "#74C7EC",
                                              blue = "#89B4FA",
                                              lavender = "#B4BEFE",
                                              text = "#CDD6F4",
                                              subtext1 = "#BAC2DE",
                                              subtext0 = "#A6ADC8",
                                              overlay2 = "#9399B2",
                                              overlay1 = "#7F849C",
                                              overlay0 = "#6C7086",
                                              surface2 = "#585B70",
                                              surface1 = "#45475A",
                                              surface0 = "#313244",

                                              base = "#1E1E2E",
                                              mantle = "#181825",
                                              crust = "#11111B",
                                            },
                                          }

                                          Theme.palette = wezterm.GLOBAL.is_dark and catppuccin.dark or catppuccin.light

                                          Theme.colors = {
                                            split = Theme.palette.surface0,
                                            foreground = Theme.palette.text,
                                            background = Theme.palette.base,
                                            cursor_bg = Theme.palette.overlay2,
                                            cursor_border = Theme.palette.overlay2,
                                            cursor_fg = Theme.palette.base,
                                            selection_bg = Theme.palette.surface2,
                                            selection_fg = Theme.palette.text,
                                            visual_bell = Theme.palette.surface0,
                                            indexed = {
                                              [16] = Theme.palette.peach,
                                              [17] = Theme.palette.rosewater,
                                            },
                                            scrollbar_thumb = Theme.palette.surface2,
                                            compose_cursor = Theme.palette.flamingo,
                                            ansi = {
                                              Theme.palette.surface0,
                                              Theme.palette.red,
                                              Theme.palette.green,
                                              Theme.palette.yellow,
                                              Theme.palette.blue,
                                              Theme.palette.mauve,
                                              Theme.palette.teal,
                                              Theme.palette.text,
                                            },
                                            brights = {
                                              Theme.palette.surface2,
                                              Theme.palette.red,
                                              Theme.palette.green,
                                              Theme.palette.yellow,
                                              Theme.palette.blue,
                                              Theme.palette.mauve,
                                              Theme.palette.teal,
                                              Theme.palette.surface2,
                                            },
                                            tab_bar = {
                                              background = Theme.palette.mantle,
                                              active_tab = {
                                                bg_color = "none",
                                                fg_color = Theme.palette.subtext1,
                                                intensity = "Bold",
                                                underline = "None",
                                                italic = false,
                                                strikethrough = false,
                                              },
                                              inactive_tab = {
                                                bg_color = Theme.palette.mantle,
                                                fg_color = Theme.palette.surface1,
                                              },
                                              inactive_tab_hover = {
                                                bg_color = Theme.palette.mantle,
                                                fg_color = Theme.palette.surface1,
                                              },
                                              new_tab = {
                                                bg_color = Theme.palette.mantle,
                                                fg_color = Theme.palette.subtext0,
                                              },
                                              new_tab_hover = {
                                                bg_color = Theme.palette.mantle,
                                                fg_color = Theme.palette.surface2,
                                              },
                                            },
                                          }

                                    local Tab = {}

                                local palette = Theme.palette
      local function get_process(tab)
      	local process_icons = {
      		["docker"] = {
      			{ Foreground = { Color = palette.blue } },
      			{ Text = "󰡨" },
      		},
      		["docker-compose"] = {
      			{ Foreground = { Color = palette.blue } },
      			{ Text = "󰡨" },
      		},
      		["nvim"] = {
      			{ Foreground = { Color = palette.green } },
      			{ Text = "" },
      		},
      		["bob"] = {
      			{ Foreground = { Color = palette.blue } },
      			{ Text = "" },
      		},
      		["vim"] = {
      			{ Foreground = { Color = palette.green } },
      			{ Text = "" },
      		},
      		["node"] = {
      			{ Foreground = { Color = palette.green } },
      			{ Text = "󰋘" },
      		},
      		["zsh"] = {
      			{ Foreground = { Color = palette.overlay1 } },
      			{ Text = "" },
      		},
      		["bash"] = {
      			{ Foreground = { Color = palette.overlay1 } },
      			{ Text = "" },
      		},
      		["htop"] = {
      			{ Foreground = { Color = palette.yellow } },
      			{ Text = "" },
      		},
      		["btop"] = {
      			{ Foreground = { Color = palette.rosewater } },
      			{ Text = "" },
      		},
      		["cargo"] = {
      			{ Foreground = { Color = palette.peach } },
      			{ Text = wezterm.nerdfonts.dev_rust },
      		},
      		["go"] = {
      			{ Foreground = { Color = palette.sapphire } },
      			{ Text = "" },
      		},
      		["git"] = {
      			{ Foreground = { Color = palette.peach } },
      			{ Text = "󰊢" },
      		},
      		["lazygit"] = {
      			{ Foreground = { Color = palette.mauve } },
      			{ Text = "󰊢" },
      		},
      		["lua"] = {
      			{ Foreground = { Color = palette.blue } },
      			{ Text = "" },
      		},
      		["wget"] = {
      			{ Foreground = { Color = palette.yellow } },
      			{ Text = "󰄠" },
      		},
      		["curl"] = {
      			{ Foreground = { Color = palette.yellow } },
      			{ Text = "" },
      		},
      		["gh"] = {
      			{ Foreground = { Color = palette.mauve } },
      			{ Text = "" },
      		},
      		["flatpak"] = {
      			{ Foreground = { Color = palette.blue } },
      			{ Text = "󰏖" },
      		},
      	}

      	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

      	if not process_name then
      		process_name = "zsh"
      	end

      	return wezterm.format(
      		process_icons[process_name]
      			or { { Foreground = { Color = palette.sky } }, { Text = string.format("[%s]", process_name) } }
      	)
      end

            local function get_current_working_folder_name(tab)
            	local cwd_uri = tab.active_pane.current_working_dir
            	cwd_uri = cwd_uri:sub(8)

            	local slash = cwd_uri:find("/")
            	local cwd = cwd_uri:sub(slash)

            	local HOME_DIR = os.getenv("HOME")
            	if cwd == HOME_DIR then
            		return "  ~"
            	end
                if string.sub(cwd, -1, -1) == "/" then
                    cwd=string.sub(cwd, 1, -2)
                end

            	return string.format("  %s", string.match(cwd, "[^/]+$"))
            end
                  function Tab.setup()
                  	wezterm.on("format-tab-title", function(tab)
                  		return wezterm.format({
                  			{ Attribute = { Intensity = "Half" } },
                  			{ Foreground = { Color = palette.surface2 } },
                  			{ Text = string.format(" %s  ", tab.tab_index + 1) },
                  			"ResetAttributes",
                  			{ Text = get_process(tab) },
                  			{ Text = " " },
                  			{ Text = get_current_working_folder_name(tab) },
                  			{ Foreground = { Color = palette.base } },
                  			{ Text = "  ▕" },
                  		})
                  	end)

                  	wezterm.on("update-right-status", function(window)
                  		window:set_right_status(wezterm.format({
                  			{ Attribute = { Intensity = "Bold" } },
                  			{ Text = wezterm.strftime(" %A, %d %B %Y %I:%M %p ") },
                  		}))
                  	end)
                  end
                              local function is_vi_process(pane)
                                return pane:get_foreground_process_name():find("n?vim") ~= nil
                              end

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
                                  mods = resize_or_move == "resize" and "SHIFT|ALT" or "ALT",
                                  action = wezterm.action_callback(function(win, pane)
                                    if is_vi_process(pane) then
                                      win:perform_action({
                                        SendKey = { key = key, mods = resize_or_move == "resize" and "SHIFT|ALT" or "ALT" },
                                      }, pane)
                                    else
                                      if resize_or_move == "resize" then
                                        win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                                      else
                                        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                                      end
                                    end
                                  end),
                                }
                              end

                        Tab.setup()
                        return {
                          font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font" }),
                          audible_bell = "Disabled",
                          font_size = 11,
                          front_end = "OpenGL",
                          underline_thickness = "200%",
                          underline_position = "-3pt",
                          enable_wayland = false,
                          pane_focus_follows_mouse = false,
                          warn_about_missing_glyphs = false,
                          show_update_window = false,
                          check_for_updates = false,
                          -- line_height = 1.3,
                          window_decorations = "RESIZE",
                          window_close_confirmation = "NeverPrompt",
                          window_padding = {
                            left = 0,
                            right = 0,
                            top = 0,
                            bottom = 0,
                          },
                          initial_cols = 110,
                          initial_rows = 25,
                          inactive_pane_hsb = {
                            saturation = 1.0,
                            brightness = wezterm.GLOBAL.is_dark and 0.90 or 0.95,
                          },
                          enable_scroll_bar = false,
                          tab_bar_at_bottom = true,
                          use_fancy_tab_bar = false,
                          show_new_tab_button_in_tab_bar = false,
                          window_background_opacity = 1.0,
                          tab_max_width = 50,
                          hide_tab_bar_if_only_one_tab = true,
                          disable_default_key_bindings = false,
                          colors = Theme.colors,
                          keys = {
                                split_nav("move", "h"),
                                split_nav("move", "j"),
                                split_nav("move", "k"),
                                split_nav("move", "l"),
                                split_nav("resize", "h"),
                                split_nav("resize", "j"),
                                split_nav("resize", "k"),
                                split_nav("resize", "l"),
                                {
                                  mods = "ALT",
                                  key = [[\]],
                                  action = wezterm.action({
                                    SplitHorizontal = { domain = "CurrentPaneDomain" },
                                  }),
                                },
                                {
                                  mods = "ALT|SHIFT",
                                  key = [[|]],
                                  action = wezterm.action.SplitPane({
                                    top_level = true,
                                    direction = "Right",
                                    size = { Percent = 50 },
                                  }),
                                },
                                {
                                  mods = "ALT",
                                  key = [[-]],
                                  action = wezterm.action({
                                    SplitVertical = { domain = "CurrentPaneDomain" },
                                  }),
                                },
                                {
                                  mods = "ALT|SHIFT",
                                  key = [[_]],
                                  action = wezterm.action.SplitPane({
                                    top_level = true,
                                    direction = "Down",
                                    size = { Percent = 50 },
                                  }),
                                },
                                {
                                  key = "n",
                                  mods = "ALT",
                                  action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
                                },
                                {
                                  key = "Q",
                                  mods = "ALT",
                                  action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
                                },
                                { key = "q",   mods = "ALT",        action = wezterm.action.CloseCurrentPane({ confirm = false }) },
                                { key = "z",   mods = "ALT",        action = wezterm.action.TogglePaneZoomState },
                                { key = "F11", mods = "",           action = wezterm.action.ToggleFullScreen },
                                { key = "[",   mods = "ALT",        action = wezterm.action({ ActivateTabRelative = -1 }) },
                                { key = "]",   mods = "ALT",        action = wezterm.action({ ActivateTabRelative = 1 }) },
                                { key = "{",   mods = "SHIFT|ALT",  action = wezterm.action.MoveTabRelative( -1) },
                                { key = "}",   mods = "SHIFT|ALT",  action = wezterm.action.MoveTabRelative(1) },
                                { key = "y",   mods = "ALT",        action = wezterm.action.ActivateCopyMode },
                                { key = "c",   mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
                                { key = "v",   mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
                                { key = "=",   mods = "CTRL",       action = wezterm.action.IncreaseFontSize },
                                { key = "-",   mods = "CTRL",       action = wezterm.action.DecreaseFontSize },
                                { key = "1",   mods = "ALT",        action = wezterm.action({ ActivateTab = 0 }) },
                                { key = "2",   mods = "ALT",        action = wezterm.action({ ActivateTab = 1 }) },
                                { key = "3",   mods = "ALT",        action = wezterm.action({ ActivateTab = 2 }) },
                                { key = "4",   mods = "ALT",        action = wezterm.action({ ActivateTab = 3 }) },
                                { key = "5",   mods = "ALT",        action = wezterm.action({ ActivateTab = 4 }) },
                                { key = "6",   mods = "ALT",        action = wezterm.action({ ActivateTab = 5 }) },
                                { key = "7",   mods = "ALT",        action = wezterm.action({ ActivateTab = 6 }) },
                                { key = "8",   mods = "ALT",        action = wezterm.action({ ActivateTab = 7 }) },
                                { key = "9",   mods = "ALT",        action = wezterm.action({ ActivateTab = 8 }) },
                              },
                          hyperlink_rules = {
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
                            {
                              regex = [[\b[tT](\d+)\b]],
                              format = "https://example.com/tasks/?t=$1",
                            },
                          },
                        }
    '';
  };
}
