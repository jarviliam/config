{
  pkgs,
  username,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = rec {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        username
      ];
      allowed-users = trusted-users;
    };

    optimise.automatic = true;
  };
}
