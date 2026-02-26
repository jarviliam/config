{ config, pkgs, ... }:
{
  services.resolved.enable = false;
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = 3000;
    mutableSettings = true;
  };
}
