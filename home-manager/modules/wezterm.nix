{ config, flakePath, pkgs, lib, ... }: {
  programs.wezterm = {
    enable = true;
  };
  xdg.configFile."wezterm/wezterm.lua".enable = false;
  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${flakePath}/home-manager/modules/wezterm";
    recursive = true;
  };
}
