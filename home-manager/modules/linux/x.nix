{ config, pkgs, lib, ... }: {
  fonts.fontconfig.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;
    monitors = {
      HDMI-1 = [ "1" "2" "3" "4" ];
      edp-1 = [ "5" "6" "7" "8" ];
    };
    settings = {
      "remove_disabled_monitors" = true;
      "remove_unplugged_monitors" = true;
      "focus_follows_pointer" = true;
      "split_ratio" = 0.52;
    };
    startupPrograms = [ "sxhkd" "systemctl --user restart polybar" ];
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    network = { startWhenNeeded = true; };
  };
  home.packages = with pkgs; [ nitrogen ];
  programs.rofi.enable = true;
  services.picom = {
    enable = true;
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
        background = true;
      };
      blur-kern = "3x3box";
      blur-background-exclude =
        [ "window_type = 'desktop'" "class_g = 'firefox'" ];
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
}
