{ pkgs, config, nixpkgs, username, ... }: {
  environment.systemPackages = [ pkgs.sketchybar ];
  # environment.profiles = ["liam.jarvis" "test"];
  services.nix-daemon.enable = true;
  homebrew.enable = true;
  homebrew.taps = ["qmk/qmk"];
  homebrew.brews = [
    "llvm"
    "clamav"
  ];
  nix.settings.allowed-users = [ "root" "liam.jarvis" ];
  nix.settings.trusted-users = [ "root" "liam.jarvis" ];
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
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
  };
}
