{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
    autoUpdate = true;
    cleanup = "zap";
    upgrade = true;
    };
  brewPrefix = "/opt/homebrew/bin";
    taps = [
  "homebrew/bundle"
  "homebrew/cask"
  "homebrew/cask-drivers"
  "homebrew/cask-fonts"
  "homebrew/core"
  "homebrew/services"
  "cmacrae/formulae" # spacebar
  "FelixKratz/formulae" # sketchybar
    ];
    casks = [
  "zoom"
  "google-chrome"
  "vlc" # media player
    ];
    brews = [
  "helm"
  "kubebuilder" # generating k8s controller
  "lima" # docker alternative
  "skhd" # keybinding manager
  # "yabai" # tiling window manager
  "sketchybar" # macos bar alternative
  "ifstat" # network
    ];
  };
}
