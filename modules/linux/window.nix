{
  pkgs,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      updateDbusEnvironment = true;
    };
    # displayManager = {
    #   defaultSession = "none+bspwm";
    #   sddm = {
    #     enable = false;
    #     enableHidpi = true;
    #   };
    # };
    # xserver = {
    #   enable = true;
    #   desktopManager = {
    #     xterm.enable = false;
    #     xfce.enable = true;
    #   };
    #   displayManager = {
    #     lightdm = {
    #       enable = true;
    #       greeter.enable = true;
    #     };
    #     startx.enable = true;
    #     setupCommands = ''
    #       external_monitor=$(${pkgs.xorg.xrandr}/bin/xrandr --query | grep 'HDMI-1 connected')
    #       if [[ $external_monitor = *connected* ]]; then
    #       ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --primary --mode 2048x1280 --rate 60 --left-of eDP-1
    #       else
    #       ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --rate 60
    #       fi
    #     '';
    #   };
    #   windowManager = {
    #     bspwm.enable = true;
    #   };
    #   xkb = {
    #     variant = "";
    #     layout = "us";
    #   };
    # };
    libinput = {
      enable = true;
      touchpad = {
        tapping = false;
        disableWhileTyping = true;
        sendEventsMode = "disabled-on-external-mouse";
      };
    };
  };
}
