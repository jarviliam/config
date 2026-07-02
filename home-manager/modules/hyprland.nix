{ pkgs, lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    exit = lua "hl.dsp.exit()";
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    fullscreen = lua "hl.dsp.window.fullscreen()";
    pseudo = lua "hl.dsp.window.pseudo()";
    layout = msg: lua ''hl.dsp.layout("${msg}")'';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
    sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
  };
  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };

  bindOpts = keys: dispatcher: opts: {
    _args = [
      keys
      dispatcher
      opts
    ];
  };

  workspaceBinds = lib.concatMap (
    i:
    let
      key = toString (lib.mod i 10);
    in
    [
      (bind "SUPER + ${key}" (dsp.focusWorkspace i))
      (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace i))
    ]
  ) (lib.range 1 5);
in
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  programs.wofi = {
    enable = true;
    settings = {
      prompt = "Search ...";
      width = "50%";
      height = "40%";
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings =
      let
        terminal = "ghostty";
        browser = "firefox";
        filemanager = "thunar";
      in
      {
        monitor = [
          {
            output = "HDMI-A-2";
            mode = "3840x2160";
            position = "0x0";
            scale = 1.50;
          }
        ];
        config = {
          general = {
            layout = "master";
            border_size = 1;
            gaps_in = 5;
            gaps_out = 5;
          };
          decoration = {
            rounding = 5;
            active_opacity = 0.95;
            inactive_opacity = 0.95;
            fullscreen_opacity = 1.0;

            blur = {
              enabled = true;
              size = 6;
              passes = 3;
              new_optimizations = true;
              xray = true;
              special = true;
              brightness = 1;
              noise = 0.01;
              contrast = 1;
              popups = true;
              popups_ignorealpha = 0.6;
            };

            shadow = {
              enabled = false;
            };
          };

          animations = {
            enabled = true;
          };

          input = {
            sensitivity = -0.7;
            scroll_method = "2 fg";
            touchpad = {
              natural_scroll = true;
              clickfinger_behavior = false;
            };
          };

          cursor = {
            no_hardware_cursors = true;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

        };

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 7;
            bezier = "default";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 7;
            bezier = "default";
            style = "popin 80%";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "borderangle";
            enabled = true;
            speed = 8;
            bezier = "default";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "default";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 6;
            bezier = "default";
          }
        ];

        bind = [
          (bind "SUPER + RETURN" (dsp.exec terminal))
          (bind "SUPER + B" (dsp.exec browser))
          (bind "SUPER + E" (dsp.exec filemanager))
          (bind "SUPER + R" (dsp.exec "wofi --show drun"))
          (bind "SUPER + SHIFT + S" (dsp.exec "flameshot gui"))

          # hyprland
          (bind "SUPER + Q" (dsp.close))
          (bind "SUPER + SHIFT + Q" dsp.exit)
          (bind "SUPER + V" dsp.float)
          (bind "SUPER + F" dsp.fullscreen)
          (bind "SUPER + P" dsp.pseudo)
          (bind "SUPER + J" (dsp.layout "swapwithmaster"))

          # shutdown
          (bind "SUPER + SHIFT + P" (dsp.exec "dms ipc call powermenu toggle"))

          # lock
          (bind "SUPER + SHIFT + L" (dsp.exec "hyprlock"))

          # change focus
          (bind "SUPER + left" (dsp.focus "left"))
          (bind "SUPER + right" (dsp.focus "right"))
          (bind "SUPER + up" (dsp.focus "up"))
          (bind "SUPER + down" (dsp.focus "down"))

          # Swap windows
          (bind "SUPER + SHIFT + left" (dsp.swap "left"))
          (bind "SUPER + SHIFT + right" (dsp.swap "right"))
          (bind "SUPER + SHIFT + up" (dsp.swap "up"))
          (bind "SUPER + SHIFT + down" (dsp.swap "down"))

          # Scroll through workspaces
          (bind "SUPER + mouse_down" (dsp.focusWorkspace "e+1"))
          (bind "SUPER + mouse_up" (dsp.focusWorkspace "e-1"))
          (bind "SUPER + tab" (dsp.focusWorkspace "e-1"))
          (bind "SUPER + SHIFT + tab" (dsp.focusWorkspace "e+1"))

          # Show Notifications
          (bind "SUPER + SHIFT + n" (dsp.exec "dms ipc call notifications toggle"))

          # resize active
          (bindOpts "SUPER + CTRL + left" dsp.resize {
            x = -20;
            y = 0;
          })
          (bindOpts "SUPER + CTRL + right" dsp.resize {
            x = 20;
            y = 0;
          })
          (bindOpts "SUPER + CTRL + up" dsp.resize {
            x = 0;
            y = -20;
          })
          (bindOpts "SUPER + CTRL + down" dsp.resize {
            x = 0;
            y = 20;
          })

          (bindOpts "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume @ 5%+") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @ 5%-") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioMute" (dsp.exec "wpctl set-mute @ toggle") { locked = true; })
          (bindOpts "XF86AudioMicMute" (dsp.exec "wpctl set-mute u/DEFAULT_AUDIO_SOURCE@ toggle") {
            locked = true;
          })
        ]
        ++ workspaceBinds;
      };

  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 0;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }

        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
