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
    open = true;
  };
}
