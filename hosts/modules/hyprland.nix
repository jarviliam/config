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
