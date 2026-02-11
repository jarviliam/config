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
  systemd = {
    services = {
      systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    # Power management is nearly always required to get nvidia GPUs to
    # behave on suspend, due to firmware bugs.
    powerManagement.enable = true;
  };
}
