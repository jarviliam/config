{ pkgs, ... }: {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    # package = "yabai-5.0.4";
    enableScriptingAddition = true;
    config = {
      window_border = "on";
      window_border_width = 2;
      active_window_border_color = "0xfff5c2e7";
      normal_window_border_color = "0xffcba6f7";
      window_border_hidpi = "on";
      focus_follows_mouse = "off";
      mouse_drop_action = "swap";
      window_placement = "second_child";
      window_opacity = "off";
      window_topmost = "on";
      window_shadow = "float";
      window_origin_display = "default";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;
      external_bar = "all:50:0";
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off

      # signals
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
    '';
  };
}
