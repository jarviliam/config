{ ... }:
{
  programs.waybar.enable = true;
  programs.wofi = {
    enable = true;
    settings = {
      prompt = "Search ...";
      width = "50%";
      height = "40%";
    };
  };
  xdg.configFile = {
    # "hypr/hyperland.conf" = {
    #   source = "${cfg}";
    # };
    "hypr/hyprpaper.conf".text = ''
      splash = false
    '';
    "hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }
    '';
  };
}
