{ pkgs, config, nixpkgs, username, ... }: {
  environment.systemPackages = [ pkgs.sketchybar ];
  services.nix-daemon.enable = true;
  nix.settings.allowed-users = [ "root" "liam.jarvis" ];
  nix.settings.trusted-users = [ "root" "liam.jarvis" ];
  fonts = {
    fontDir.enable = false;
    fonts = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };
  programs.zsh.enable = true;
  users.users."${username}" = {
    name = username;
    home = "/Users/${username}";
  };
  system = {
    keyboard = {
      enableKeyMapping = true; # Needed for skhd
    };
  };
}
