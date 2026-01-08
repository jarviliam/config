{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
  };
  security.polkit.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprlock = { };
    gdm.enableGnomeKeyring = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    pavucontrol
    loupe
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    waybar
    libnotify
    wl-clipboard
  ];
}
