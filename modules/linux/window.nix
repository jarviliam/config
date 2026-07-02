{
  ...
}:
{
  services.displayManager.gdm.enable = false;
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      updateDbusEnvironment = true;
    };
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
