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
    "usbcore.quirks=4653:0004:g"
    "usbcore.autosuspend=-1"
  ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="4653", ATTRS{idProduct}=="0004", MODE="0666", TAG+="uaccess", TAG+="seat"
  '';

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # Power management is nearly always required to get nvidia GPUs to
    # behave on suspend, due to firmware bugs.
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

}
