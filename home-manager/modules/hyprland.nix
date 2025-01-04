{
  pkgs,
  lib,
  ...
}:
let
  cfg = ../../config/hypr/hyperland.conf;
in
{
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];
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
