{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/hyprland.nix
  ];

  my.meta.roles = [
    "dev"
    "graphical"
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.blex-mono
    ];
  };

  hardware.keyboard.qmk.enable = true;
  boot.kernelParams = [
    # Forces old-style enumeration sequence (gives QMK time to answer ep0)
    "usbcore.old_scheme_first=y"
    # Ignores initial descriptor fetch timeouts
    "usbcore.initial_descriptor_timeout=30"
    # Disables runtime power management on the USB subsystem
    "usbcore.autosuspend=-1"
  ];
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];
  # # Disable autosuspend for all USB keyboards
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTR{bInterfaceSubClass}=="01", ATTR{bInterfaceProtocol}=="01", ATTR{power/control}="on"
  #
  # # Disable autosuspend for USB hubs to prevent hub suspension issues
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", ATTR{power/control}="on"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", ATTR{power/control}="on"

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # Power management is nearly always required to get nvidia GPUs to
    # behave on suspend, due to firmware bugs.
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

}
