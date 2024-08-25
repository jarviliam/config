{ pkgs, lib, nixvim, ... }:
{
  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
