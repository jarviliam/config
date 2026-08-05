{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  security.polkit.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprlock = { };
    gdm.enableGnomeKeyring = true;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    loupe
    hyprlock
    hypridle
    hyprpicker
    libnotify
    wl-clipboard
  ];
}
