{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/hyprland.nix
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };
}
