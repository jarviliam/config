{ config, pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
  };
}
