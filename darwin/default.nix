{ config, pkgs, nixpkgs, ... }:
let in
{
  imports = [ ./homebrew ];
  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  services.nix-daemon.enable = true;
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    etBook
    fira-code
    font-awesome
    nerdfonts
    roboto
    roboto-mono
  ];
  services.skhd.enable = true;
  services.skhd.skhdConfig = builtins.readFile ./skhd.conf;
  system.keyboard = {
    enableKeyMapping = true;
  };
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };

    spaces.spans-displays = false;
    screencapture.location = "/tmp";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain._HIHideMenuBar = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    promptInit = "";
  };
}

