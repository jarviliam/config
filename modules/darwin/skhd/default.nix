{ lib, pkgs, config, ... }: {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # focus window
          cmd + alt - h : yabai -m window --focus west
          cmd + alt - j : yabai -m window --focus south
          cmd + alt - k : yabai -m window --focus north
          cmd + alt - l : yabai -m window --focus east

      # swap managed window
          shift + cmd - h : yabai -m window --swap west
          shift + cmd - j : yabai -m window --swap south
          shift + cmd - k : yabai -m window --swap north
          shift + cmd - l : yabai -m window --swap east

      # move managed window
          shift + cmd + ctrl - h : yabai -m window --warp west
          shift + cmd + ctrl - j : yabai -m window --warp south
          shift + cmd + ctrl - k : yabai -m window --warp north
          shift + cmd + ctrl - l : yabai -m window --warp east

      # rotate tree
          cmd + shift + alt - r : yabai -m space --rotate 90

      # toggle window fullscreen zoom
          cmd + alt - f : yabai -m window --toggle zoom-fullscreen

          cmd + alt - s : yabai -m window --toggle sticky

      # toggle padding and gap
          cmd + alt - g : yabai -m space --toggle padding
      # yabai -m space --toggle gap

      # float / unfloat window and center on screen
          cmd + alt - t : yabai -m window --toggle float
      # yabai -m window --grid 4:4:1:1:2:2

      # toggle window split type
          cmd + alt - e : yabai -m window --toggle split

      # balance size of windows
          shift + cmd - 0 : yabai -m space --balance

      # move window and focus desktop
          shift + cmd - 1 : yabai -m window --space 1 && yabai -m space --focus 1
          shift + cmd - 2 : yabai -m window --space 2 && yabai -m space --focus 2
          shift + cmd - 3 : yabai -m window --space 3 && yabai -m space --focus 3
          shift + cmd - 4 : yabai -m window --space 4 && yabai -m space --focus 4
          shift + cmd - 5 : yabai -m window --space 5 && yabai -m space --focus 5
          shift + cmd - 6 : yabai -m window --space 6 && yabai -m space --focus 6
          shift + cmd - 7 : yabai -m window --space 7 && yabai -m space --focus 7
          shift + cmd - 8 : yabai -m window --space 8 && yabai -m space --focus 8
          shift + cmd - 9 : yabai -m window --space 9 && yabai -m space --focus 9

      # fast focus desktop
          cmd + alt - tab : yabai -m space --focus recent

      # send window to monitor and follow focus
          cmd + alt - n : yabai -m window --display next && yabai -m display --focus next
          cmd + alt - p : yabai -m window --display previous && yabai -m display --focus previous

          # cmd - return : ${pkgs.wezterm}/bin/wezterm connect unix
          cmd - return : ${pkgs.wezterm}/bin/wezterm
          # cmd - return : /etc/profiles/per-user/liam.jarvis/bin/wezterm
    '';
  };
  launchd.user.agents.skhd.serviceConfig = {
    StandardOutPath = "/tmp/skhd.out.log";
    StandardErrorPath = "/tmp/skhd.err.log";
  };
}
