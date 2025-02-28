{
  pkgs,
  username,
  ...
}:
{
  nix.enable = true;
  # services.nix-daemon.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    brews = [
      "llvm"
      "clamav"
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
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
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
