{config,pkgs,lib, ...}:
{
  services = {
    xserver = {
        enable = true;
        desktopManager = {
            xterm.enable = false;
        };
        displayManager = { 
            lightdm.enable = true;
            lightdm.greeter.enable = true;
            startx.enable = true;
            defaultSession = "none+bspwm";
            setupCommands = ''
                external_monitor=$(${pkgs.xorg.xrandr}/bin/xrandr --query | grep 'HDMI-1 connected')
                if [[ $external_monitor = *connected* ]]; then
                ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --primary --mode 2048x1280 --rate 60 --left-of eDP-1
                else
                ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --rate 60
                fi
            '';
        };
        desktopManager.xfce.enable = true;
        windowManager.bspwm.enable = true;
        layout = "us";
        xkbVariant = "";
    libinput = { 
        enable = true;
        touchpad = {
            tapping = false;
            disableWhileTyping = true;
            sendEventsMode = "disabled-on-external-mouse";
        };
    };
    };
  };
}
