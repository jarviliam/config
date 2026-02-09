{ ... }:
{
  programs.waybar.enable = true;
  services.swaync.enable = true;
  programs.wofi = {
    enable = true;
    settings = {
      prompt = "Search ...";
      width = "50%";
      height = "40%";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings =
      let
        border_size = 0;
        gaps_in = 5;
        gaps_out = 10;
        gaps_ws = -10;
        rounding = 8;
        terminal = "ghostty";
        browser = "firefox";
        filemanager = "thunar";
      in
      {
        monitor = ",preferred,auto,auto";
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

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };
        general = {
          border_size = border_size;
          gaps_in = gaps_in;
          gaps_out = gaps_out;
          gaps_workspaces = gaps_ws;
          layout = "master";
          resize_on_border = true;
        };
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        decoration = {
          rounding = rounding;
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

          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1" # use with .2s duration
          ];

          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 3, menu_decel"
            "fadeLayersOut, 1, 1.6, menu_accel"
            "workspaces, 1, 3, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        #-- Layout : Master
        # See https://wiki.hyprland.org/Configuring/Master-Layout
        master = {
          allow_small_split = false;
          special_scale_factor = 0.8;
          mfact = 0.5;
          new_on_top = false;
          orientation = "left";
          smart_resizing = true;
          drop_at_cursor = true;
        };

        bind = [
          # apps
          "SUPER, Return, exec, ${terminal}"
          "SUPER, F, exec, ${filemanager}"
          "SUPER, B, exec, ${browser}"
          "SUPER, V, exec, copyq show"
          "SUPER, R, exec, wofi --show drun"

          # "SUPER_SHIFT, Return, exec, ${floating_terminal}"
          "SUPER_SHIFT, S, exec, flameshot gui"

          # tpanel
          # "SUPER, A, exec, ags toggle launcher"
          # "SUPER_SHIFT, B, exec, ags toggle bar"
          # "SUPER_SHIFT, C, exec, ags toggle control-center"
          # "SUPER_SHIFT, W, exec, ags toggle wallpaper-manager"
          # "SUPER_SHIFT, R, exec, ags quit; ${pkgs.tpanel}/bin/tpanel"

          # hyprland
          "SUPER, Q, killactive"
          # "SUPER, grave, hyprexpo:expo, toggle"
          "SUPER_SHIFT, Q, forcekillactive"
          "SUPER_SHIFT, F, fullscreen, 0"
          "SUPER_SHIFT, Space, exec, hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 1200 800; hyprctl dispatch centerwindow;"

          # shutdown
          "SUPER_SHIFT, P, exec, poweroff"

          # lock
          "SUPER_SHIFT, L, exec, hyprlock"

          # change focus
          "SUPER, left,  movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up,    movefocus, u"
          "SUPER, down,  movefocus, d"

          # move active
          "SUPER_SHIFT, left,  movewindow, l"
          "SUPER_SHIFT, right, movewindow, r"
          "SUPER_SHIFT, up,    movewindow, u"
          "SUPER_SHIFT, down,  movewindow, d"

          # workspaces
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"

          "SUPER, tab, workspace, -1"
          "SUPER_SHIFT, tab, workspace, +1"

          # send to workspaces
          "SUPER_SHIFT, 1, movetoworkspacesilent, 1"
          "SUPER_SHIFT, 2, movetoworkspacesilent, 2"
          "SUPER_SHIFT, 3, movetoworkspacesilent, 3"
          "SUPER_SHIFT, 4, movetoworkspacesilent, 4"
          "SUPER_SHIFT, 5, movetoworkspacesilent, 5"
        ];
        binde = [
          # resize active
          "SUPER_CTRL, left,  resizeactive, -20 0"
          "SUPER_CTRL, right, resizeactive, 20 0"
          "SUPER_CTRL, up,    resizeactive, 0 -20"
          "SUPER_CTRL, down,  resizeactive, 0 20"

          # move active (Floating Only)
          "SUPER_ALT, left,  moveactive, -20 0"
          "SUPER_ALT, right, moveactive, 20 0"
          "SUPER_ALT, up,    moveactive, 0 -20"
          "SUPER_ALT, down,  moveactive, 0 20"
          "SUPER_ALT, equal, exec, hyprctl dispatch centerwindow;"

          # speaker and mic volume control
          " , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"
          " , XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%-"
          " , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          " , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # display and keyboard brightness control
          " , XF86MonBrightnessUp, exec, brightnessctl s +20%"
          " , XF86MonBrightnessDown, exec, brightnessctl s 20%-"
          " , XF86KbdBrightnessUp, exec, asusctl -n"
          " , XF86KbdBrightnessDown, exec, asusctl -p"

          # performance
          " , XF86Launch4, exec, asusctl profile -n"
        ];

        "exec-once" = [
          "waybar"
        ];
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
          blur_passes = 3;
          blur_size = 8;
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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Wallpapers/house.png"
      ];
      wallpaper = [
        {
          monitor = "HDMI-A-2";
          path = "~/Wallpapers/house.png";
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
