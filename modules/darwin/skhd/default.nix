{ lib, pkgs, config, ... }: {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # focus window
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

      # swap managed window
          shift + alt - h : yabai -m window --swap west
          shift + alt - j : yabai -m window --swap south
          shift + alt - k : yabai -m window --swap north
          shift + alt - l : yabai -m window --swap east

      # move managed window
          shift + alt + ctrl - h : yabai -m window --warp west
          shift + alt + ctrl - j : yabai -m window --warp south
          shift + alt + ctrl - k : yabai -m window --warp north
          shift + alt + ctrl - l : yabai -m window --warp east

      # rotate tree
          shift + alt - r : yabai -m space --rotate 90

      # toggle window fullscreen zoom
          shift + alt - f : yabai -m window --toggle zoom-fullscreen

          shift + alt - s : yabai -m window --toggle sticky

      # toggle padding and gap
          alt - g : yabai -m space --toggle padding
      # yabai -m space --toggle gap

      # float / unfloat window and center on screen
          shift + alt - t : yabai -m window --toggle float
      # yabai -m window --grid 4:4:1:1:2:2

      # toggle window split type
          shift + alt - e : yabai -m window --toggle split

      # balance size of windows
          shift + alt - 0 : yabai -m space --balance

        cmd - f1 : yabai -m space --focus 1
        cmd - f2 : yabai -m space --focus 2
        cmd - f3 : yabai -m space --focus 3
        cmd - f4 : yabai -m space --focus 4
        cmd - f5 : yabai -m space --focus 5
        cmd - f6 : yabai -m space --focus 6
        cmd - f7 : yabai -m space --focus 7

      # move window and focus desktop
          shift + cmd - f1 : yabai -m window --space 1 && yabai -m space --focus 1
          shift + cmd - f2 : yabai -m window --space 2 && yabai -m space --focus 2
          shift + cmd - f3 : yabai -m window --space 3 && yabai -m space --focus 3
          shift + cmd - f4 : yabai -m window --space 4 && yabai -m space --focus 4
          shift + cmd - f5 : yabai -m window --space 5 && yabai -m space --focus 5
          shift + cmd - f6 : yabai -m window --space 6 && yabai -m space --focus 6
          shift + cmd - f7 : yabai -m window --space 7 && yabai -m space --focus 7

      # fast focus desktop
          cmd - f10 : yabai -m space --focus recent

      # send window to monitor and follow focus
          shift + alt - n : yabai -m window --display next && yabai -m display --focus next
          shift + alt - p : yabai -m window --display previous && yabai -m display --focus previous

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
