{
  pkgs,
  ...
}:
{
  services.displayManager.gdm.enable = true;
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
