{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/hyprland.nix
  ];
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.blex-mono
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    # Power management is nearly always required to get nvidia GPUs to
    # behave on suspend, due to firmware bugs.
    powerManagement.enable = true;
    nvidiaSettings = true;
  };
}
