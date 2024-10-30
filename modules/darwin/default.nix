{ pkgs, username, ... }:
{
  services.nix-daemon.enable = true;
  homebrew = {
    enable = true;
    taps = [ "qmk/qmk" ];
    brews = [
      "llvm"
      "clamav"
      "qmk"
    ];
  };
  nix.settings.allowed-users = [
    "root"
    "liam.jarvis"
  ];
  nix.settings.trusted-users = [
    "root"
    "liam.jarvis"
  ];
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "NerdFontsSymbolsOnly"
        ];
      })
      victor-mono
      ibm-plex
    ];
  };
  programs.zsh.enable = true;
  users.users."${username}" = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
  system = {
    keyboard = {
      enableKeyMapping = true; # Needed for skhd
    };
    stateVersion = 5;
  };

}
