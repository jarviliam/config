{config,pkgs,lib,...}:{
fonts.fontconfig.enable = true;
xsession.windowManager.bspwm = {
enable = true;
monitors = {
	HDMI-1 = ["1" "2" "3" "4"];
	edp-1 = ["5" "6" "7" "8"];
};
settings = {
      "remove_disabled_monitors" = true;
      "remove_unplugged_monitors" = true;
      "focus_follows_pointer" = true;
      "split_ratio" = 0.52;
};
startupPrograms = [ "sxhkd" "systemctl --user restart polybar" ];
};

programs.rofi.enable = true;
services.picom = {
 enable = true;
    package = pkgs.picom-next;
    settings = {
      # Shadows
      shadow = true;
      shadow-radius = 6;
      shadow-opacity = 0.5;
      shadow-offset-x = 3;
      shadow-offset-y = 3;
      shadow-exlude = [
        "window_type = 'desktop'"
        "window_type = 'dock'"
        "class_g = 'Polybar'"
        "class_g = 'firefox' && argb"
      ];
      # Fading
      fading = true;
      fade-in-step = 0.1;
      fade-out-step = 0.1;
      # Corners
      detect-rounded-corners = true;
      corner-radius = 12.0;
      round-borders = 1;
      rounded-corners-exclude = [
        "window_type = 'desktop'"
        "window_type = 'dock'"
        "class_g = 'Polybar'"
        "class_g = 'dunst'"
        "class_g = 'firefox'"
      ];
      # Blur
      blur = {
        method = "dual_kawase";
        strength = 3;
        background=true;
      };
      blur-kern = "3x3box";
      blur-background-exclude = [
        "window_type = 'desktop'"
        "class_g = 'firefox'"
      ];
      # Other
      daemon = true;
      backend = "glx";
      vsync = true;
      use-damage = true;
      log-level = "warn";
      xrender-sync-fence = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = false;
      detect-client-opacity = true;
      detect-transient = true;
      wintypes = {
        tooltip = { fade = true; };
        dock = { shadow = true; };
        dnd = { shadow = true; };
        popup_menu = { opacity = 1; };
        dropdown_menu = { opacity = 0.8; };
      };
    };
};

services.sxhkd = {
enable = true;
keybindings = {
    "super + Escape" = "pkill -USR1 -x sxhkd";
      # Restarts bspwm (most when testing out configurations)
      "super + shift + r" = "bspc wm -r";
      "super + {_,shift + }q" = "bspc node -{c,k}";

      # Opening common commands
      "super + Return" = "${pkgs.wezterm}/bin/wezterm";
      "super + r" = "rofi -show drun";
      "super + w" = "firefox";

      # Moving around windows
      "super + alt + {1-8}" = "bspc desktop -f ^{1-8}";
        # Throw window
      "super + shift + {1-8}" = "bspc node -d ^{1-8}";
       # focus
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
        # swap
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
    # toggles
      "super + {_,ctrl + }f" = "bspc node -t ~{fullscreen,floating}";
      "super + space" = "bspc node -s biggest.local || bspc node -s next.local";

};
};

services.polybar = {
    enable = true;
    script = "exec polybar main &";
    settings = let
  icons = {
    cpu = "";
    memory = "";
    date = "";
    microphone = "";
    microphone-muted = "";
    microphone-disconnected = "";
    wifi = "";
    up = "";
    down = "";
    ethernet = "";
    envelope = "";
  };
  color = {
    foreground = "#e0def4";
    background = "#191724";
    yellow = "#f6c177";
    red = "#eb6f92";
    blue = "#31748f";
    green = "#9ece6a";
    altblack = "#6e6a86";
    cyan = "#ebbcba";

    };
    in {
        "settings" = {
            throttle-output = 5;
            throttle-output-for = 10;
            throttle-input-for = 30;
            screenchange-reload = false;
            compositing-background = "source";
            compositing-foreground = "over";
            compositing-overline = "over";
            compositing-underline = "over";
            compositing-border = "over";
        };
"module/volume" = {
type = "internal/pulseaudio";
use-ui-max = false;
interval = 5;
format-volume = "<ramp-volume>  <label-volume>";
format-muted = "<label-muted>";
format-muted-prefix = "婢";
format-muted-prefix-font = 2;
format-muted-prefix-foreground = color.red;
label-volume = "%percentage%%";
label-muted = "  Muted";
label-muted-foreground = "#757575";
ramp-volume-0 = "奄";
ramp-volume-1 = "奄";
ramp-volume-2 = "奄";
ramp-volume-3 = "奔";
ramp-volume-4 = "奔";
ramp-volume-5 = "奔";
ramp-volume-6 = "墳";
ramp-volume-7 = "墳";
ramp-volume-8 = "墳";
ramp-volume-9 = "墳";
ramp-volume-font = 2;
ramp-volume-foreground = color.blue;
ramp-headphones-0 = "";
ramp-headphones-1 = "";
};
        "module/date" = {
          type = "internal/date";
          interval = "5";
          date = "%a %b %d";
          date-alt = "%Y-%m-%d";
          time = "%H:%M";
          time-alt = "%H:%M";
          format-underline = "#2406E8";
          label = "${icons.date} %date% %time%";
        };
        "module/empty-space" = {
            type = "custom/text";
            content = " ";
          };
        "module/backlight" = {
            type = "internal/xbacklight";
            card = "intel_backlight";
            format = "<ramp> <label>";
            format-background = color.background;
            label = "%percentage%";
            label-foreground = color.yellow;
            ramp = [ "" "" "" "" "" "" "" "" "" ""];
            ramp-font = 2;
            ramp-foreground = color.yellow;
          };
        "module/battery" = {
            type = "internal/battery";
            full-at = 99;
            battery = "BAT0";
            adapter = "ACAD";
            poll-interval = 2;
            time-format = "%H:%M";
            format-charging = "<animation-charging> <label-charging>";
            format-charging-prefix = "";
            format-discharging = "<ramp-capacity> <label-discharging>";
            format-full = "<label-full>";
            format-full-prefix = "  ";
            format-full-prefix-font = 2;
            format-full-prefix-foreground = color.red;
            label-charging = "%percentage%%";
            label-discharging = "%percentage%%";
            label-full = "%percentage%%";
            ramp-capacity-0 = "  ";
            ramp-capacity-1 = "  ";
            ramp-capacity-2 = "  ";
            ramp-capacity-3 = "  ";
            ramp-capacity-4 = "  ";
            ramp-capacity-font = 2;
            ramp-capacity-foreground = color.yellow;

            animation-charging-0 = "  ";
            animation-charging-1 = "  ";
            animation-charging-2 = "  ";
            animation-charging-3 = "  ";
            animation-charging-4 = "  ";
            animation-charging-font = 2;
            animation-charging-foreground = color.green;
            animation-charging-framerate = 750;
            };
            "module/memory"={
type = "internal/memory";
interval = 3;
format = "<label>";
format-background = color.background;
format-prefix = " ";
format-prefix-font = 2;
format-prefix-foreground = color.green;
label = " %mb_used%";
    };
          "module/bspwm" = {
            type = "internal/bspwm";
            pin-workspaces = true;
            enable-click = true;
            enable-scroll = true;
            ws-icon = [ "1;" "2;" "3;" "4;漣"];
            ws-icon-default = "";

            format = "<label-state>";
            format-padding = 0;
            format-font = 2;
            label-monitor = "%name%";

            label-focused = "%icon%";
            label-focused-foreground = color.blue;
            label-focused-background = color.background;
            label-focused-underline =  color.background;
            label-focused-padding = 1;

            label-occupied = "%icon%";
            label-occupied-foreground = color.cyan;
            label-occupied-background = color.background;
            label-occupied-padding = 1;

            label-urgent = "%icon%";
            label-urgent-foreground = color.red;
            label-urgent-background = color.background;
            label-urgent-underline =  color.red;
            label-urgent-padding = 1;

            label-empty = "%icon%";
            label-empty-foreground = color.foreground;
            label-empty-padding = 1;
            };

            "module/launcher"={
                type = "custom/text";
                content ="  ";
                content-font = 2;
                content-foreground = color.blue;
                content-background = color.background;
                content-padding = 0;
                click-left = "rofi -show drun";
            };
            "module/spacing" = {
                type = "custom/text";
                content = " ";
                content-background = color.background;
            };
            "module/sep" = {
                type = "custom/text";
                content = " ";
                content-font = 3;
                content-padding = 2;
                content-foreground = color.foreground;
                content-background = color.background;
            };

            "module/network" = {
                type = "internal/network";
                interface = "wlp2s0";
                interval = 1.0;
                accumulate-stats = true;
                unknown-as-up = true;
                format-connected = "<ramp-signal><label-connected>";
                format-disconnected = "<label-disconnected>";
                format-disconnected-prefix = " 睊 ";
                format-disconnected-prefix-font = 2;
                format-disconnected-foreground = color.green;
                format-disconnected-background = color.background;

                label-connected = "%{A1:def-nmdmenu &:}%essid%%{A} ";
                label-disconnected = "%{A1:def-nmdmenu &:}Offline%{A} ";

                label-connected-foreground = color.green;
                label-disconnected-foreground = color.green;
                label-connected-background = color.background;
                label-disconnected-background = color.background;

                ramp-signal = [ "   " "   " "   " "   " "   " ];
                ramp-signal-foreground = color.green;
                ramp-signal-background = color.background;
                ramp-signal-font = 3;
            };

            "module/sysmenu" = {
                 type = "custom/text";
                 content = " 襤";
                 content-font=2;
                 content-foreground = color.red;
                 content-padding = 0;
            };

            "global/wm" = {
                margin-bottom = 0;
                margin-top = 0;
            };

            "bar/main" = {
                monitor = "\${env:MONITOR:HDMI-1}";
                bottom = false;
                width = "90%";
                height = 30;
                offset-x = "5%";
                offset-y = 10;
                fixed-center = true;
                background = color.background;
                foreground = color.foreground;
                line-size = 2;
                line-color = color.blue;
                border-size = 4;
                radius-top = 0.0;
                radius-bottom = 0.0;
                wm-restack = "bspwm";
                font-0 = "JetBrains Mono Nerd Font:size=10:weight=bold;3";
                font-1 = "Iosevka Nerd Font:size=12;3";
                font-2 = "Iosevka Nerd Font:size=16;4";
                font-3 = "Iosevka Nerd Font:size=18;4";
                font-4 = "Source Code Pro Bold:size=12;3";
                dim-value = 1.0;
                enable-ipc = true;

                modules-left = "launcher bspwm";
                modules-center = "";
                modules-right = "memory sep battery sep volume sep date sep";

                padding = 1;
                module-margin-left = 1;
                module-margin-right = 1;
              };
      };
  };
}
