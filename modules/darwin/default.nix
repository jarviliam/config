{ pkgs
, config
, nixpkgs
, username
, ...
}:
{
  services.nix-daemon.enable = true;
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
}
